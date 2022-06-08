Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38834543EE0
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 23:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiFHVxr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 17:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiFHVxq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 17:53:46 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AB361CFF2;
        Wed,  8 Jun 2022 14:53:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CA0DC10E755A;
        Thu,  9 Jun 2022 07:53:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nz3cT-004Jeu-8P; Thu, 09 Jun 2022 07:53:41 +1000
Date:   Thu, 9 Jun 2022 07:53:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/020: adjust max_attrval_size for ceph
Message-ID: <20220608215341.GU1098723@dread.disaster.area>
References: <20220607151513.26347-1-lhenriques@suse.de>
 <20220607151513.26347-2-lhenriques@suse.de>
 <20220608001642.GS1098723@dread.disaster.area>
 <YqBwAHhf8Bzk7VSa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YqBwAHhf8Bzk7VSa@suse.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a11a68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=8nJEP1OIZ-IA:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=j3QlSqe6CAlGx3RROSAA:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 08, 2022 at 10:46:40AM +0100, Luís Henriques wrote:
> On Wed, Jun 08, 2022 at 10:16:42AM +1000, Dave Chinner wrote:
> > On Tue, Jun 07, 2022 at 04:15:12PM +0100, Luís Henriques wrote:
> > > CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
> > > size for the full set of an inode's xattrs names+values, which by default
> > > is 64K but it can be changed by a cluster admin.
> > 
> > So given the max attr name length is fixed by the kernel at 255
> > bytes (XATTR_NAME_MAX), that means the max value length is somewhere
> > around 65000 bytes, not 1024 bytes?
> 
> Right, but if the name is smaller (and in this test specifically we're not
> using that XATTR_NAME_MAX), then that max value is > 65000.  Or if the
> file already has some attributes set (which is the case in this test),
> then this maximum will need to be adjusted accordingly.  (See below.)
> 
> > Really, we want to stress and exercise max supported sizes - if the
> > admin reduces the max size on their test filesystems, that's not
> > something we should be trying to work around in the test suite by
> > preventing the test code from ever exercising attr values > 1024
> > bytes.....
> 
> Agreed.  Xiubo also noted that and I also think this test shouldn't care
> about other values.  I should drop (or at least rephrase) the reference to
> different values in the commit text.
> 
> On Wed, Jun 08, 2022 at 04:41:25PM +0800, Xiubo Li wrote:
> ...
> > Why not fixing this by making sure that the total length of 'name' + 'value'
> > == 64K instead for ceph case ?
> 
> The reason why I didn't do that is because the $testfile *already* has
> another attribute set when we set this max value:
> 
> user.snrub="fish2\012"
> 
> which means that the maximum for this case will be:
> 
>  65536 - $max_attrval_namelen - strlen("user.snrub") - strlen("fish2\012")
> 
> I'll split the _attr_get_max() function in 2:
> 
>  * _attr_get_max() sets max_attrs which is needed in several places in
>    generic/020
>  * _attr_get_max_size() sets max_attrval_size, and gets called immediately
>    before that value is needed so that it can take into account the
>    current state.
> 
> Does this sound reasonable?

It seems like unnecessary additional complexity - keep it simple.
Just set the max size for ceph to ~65000 and add a comment that says
max name+val length for all ceph attrs is 64k and we need enough
space of that space for two attr names...


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
