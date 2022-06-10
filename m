Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FC7545D50
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 09:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346764AbiFJH0l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 03:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346738AbiFJH0U (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 03:26:20 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 195FD1F5E17;
        Fri, 10 Jun 2022 00:25:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E220F10E74BD;
        Fri, 10 Jun 2022 17:25:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzZ1d-004rwl-2U; Fri, 10 Jun 2022 17:25:45 +1000
Date:   Fri, 10 Jun 2022 17:25:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        fstests@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] generic/486: adjust the max xattr size
Message-ID: <20220610072545.GY1098723@dread.disaster.area>
References: <20220609105343.13591-1-lhenriques@suse.de>
 <20220609105343.13591-3-lhenriques@suse.de>
 <4c4572a2-2681-c2f7-a8dc-55eb2f5fc077@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c4572a2-2681-c2f7-a8dc-55eb2f5fc077@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a2f1fd
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=8nJEP1OIZ-IA:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=juXdShRODsMEiqkiXVUA:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 10, 2022 at 01:35:36PM +0800, Xiubo Li wrote:
> 
> On 6/9/22 6:53 PM, Luís Henriques wrote:
> > CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
> > size for the full set of xattrs names+values, which by default is 64K.
> > And since ceph reports 4M as the blocksize (the default ceph object size),
> > generic/486 will fail in this filesystem because it will end up using
> > XATTR_SIZE_MAX to set the size of the 2nd (big) xattr value.
> > 
> > The fix is to adjust the max size in attr_replace_test so that it takes
> > into account the initial xattr name and value lengths.
> > 
> > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > ---
> >   src/attr_replace_test.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
> > index cca8dcf8ff60..1c8d1049a1d8 100644
> > --- a/src/attr_replace_test.c
> > +++ b/src/attr_replace_test.c
> > @@ -29,6 +29,11 @@ int main(int argc, char *argv[])
> >   	char *value;
> >   	struct stat sbuf;
> >   	size_t size = sizeof(value);
> > +	/*
> > +	 * Take into account the initial (small) xattr name and value sizes and
> > +	 * subtract them from the XATTR_SIZE_MAX maximum.
> > +	 */
> > +	size_t maxsize = XATTR_SIZE_MAX - strlen(name) - 1;
> 
> Why not use the statfs to get the filesystem type first ? And then just
> minus the strlen(name) for ceph only ?

No. The test mechanism has no business knowing what filesystem type
it is running on - the test itself is supposed to get the limits for
the filesystem type from the test infrastructure.

As I've already said: the right thing to do is to pass the maximum
attr size for the test to use via the command line from the fstest
itself. As per g/020, the fstests infrastructure is where we encode
weird fs limit differences and behaviours based on $FSTYP.  Hacking
around weird filesystem specific behaviours deep inside random bits
of test source code is not maintainable.

AFAIA, only ceph is having a problem with this test, so it's trivial
to encode into g/486 with:

# ceph has a weird dynamic maximum xattr size and block size that is
# much, much larger than the maximum supported attr size. Hence the
# replace test can't auto-probe a sane attr size and so we have
# to provide it with a maximum size that will work.
max_attr_size=65536
[ "$FSTYP" = "ceph" ] && max_attr_size=64000
attr_replace_test -m $max_attr_size .....
.....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
