Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632C6543EF1
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 00:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiFHV75 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 17:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiFHV7y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 17:59:54 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DE5815FD1;
        Wed,  8 Jun 2022 14:59:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EDBDE5ECF60;
        Thu,  9 Jun 2022 07:59:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nz3iQ-004Jv5-2n; Thu, 09 Jun 2022 07:59:50 +1000
Date:   Thu, 9 Jun 2022 07:59:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] src/attr_replace_test: dynamically adjust the max
 xattr size
Message-ID: <20220608215950.GV1098723@dread.disaster.area>
References: <20220607151513.26347-1-lhenriques@suse.de>
 <20220607151513.26347-3-lhenriques@suse.de>
 <20220608002315.GT1098723@dread.disaster.area>
 <YqByggmCzXGAosM+@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YqByggmCzXGAosM+@suse.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a11bd8
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=8nJEP1OIZ-IA:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=oNu-k_2LH3AzcQEeVDoA:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 08, 2022 at 10:57:22AM +0100, Luís Henriques wrote:
> On Wed, Jun 08, 2022 at 10:23:15AM +1000, Dave Chinner wrote:
> > On Tue, Jun 07, 2022 at 04:15:13PM +0100, Luís Henriques wrote:
> > > CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
> > > size for the full set of an inode's xattrs names+values, which by default
> > > is 64K but it can be changed by a cluster admin.
> > > 
> > > Test generic/486 started to fail after fixing a ceph bug where this limit
> > > wasn't being imposed.  Adjust dynamically the size of the xattr being set
> > > if the error returned is -ENOSPC.
> > 
> > Ah, this shouldn't be getting anywhere near the 64kB limit unless
> > ceph is telling userspace it's block size is > 64kB:
> > 
> > size = sbuf.st_blksize * 3 / 4;
> > .....
> > size = MIN(size, XATTR_SIZE_MAX);
> 
> Yep, that's exactly what is happening.  The cephfs kernel client reports
> here the value that is being used for ceph "object size", which defaults
> to 4M.  Hence, we'll set size to XATTR_SIZE_MAX.

Yikes. This is known to break random applications that size buffers
based on a multiple of sbuf.st_blksize and assume that it is going
to be roughly 4kB. e.g. size a buffer at 1024 * sbuf.st_blksize,
expecting to get a ~4MB buffer, and instead it tries to allocate
a 4GB buffer....

> > Regardless, the correct thing to do here is pass the max supported
> > xattr size from the command line (because fstests knows what that it
> > for each filesystem type) rather than hard coding
> > XATTR_SIZE_MAX in the test.
> 
> OK, makes sense.  But then, for the ceph case, it becomes messy because we
> also need to know the attribute name to compute the maximum size.  I guess
> we'll need an extra argument for that too.

Just pass in a size for ceph that has enough spare space for the
attribute names in it, like for g/020. Don't make it more
complex than it needs to be.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
