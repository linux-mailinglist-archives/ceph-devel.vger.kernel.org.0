Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0D35BAE0
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 13:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbfGALmO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 07:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbfGALmO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 07:42:14 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A20CB2089C;
        Mon,  1 Jul 2019 11:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561981333;
        bh=vgsUGU3DFk4AnrNLxjU9qo9yPdfWgCeceTSrvfdJkJw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SucrO2f6SHZj9smmbjx58fFZ/ssnBC5e75mZFzRbO2HR+oHUEgEYvUwnUCRas1wQr
         NpvXCUeRLmUlnJWyXXBfXXqTTfdxwEil7uK9mxSC8+hfl/I+99xroyyMqgMr5lKQ/T
         G4U/UtTjzbJv2D9eTl6ciLTG0PhateWnH4pQqJM8=
Message-ID: <ace39346ca2059503901f2100fcc350b18bd9cdc.camel@kernel.org>
Subject: Re: [PATCH] ceph: use ceph_evict_inode to cleanup inode's resource
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Date:   Mon, 01 Jul 2019 07:42:11 -0400
In-Reply-To: <CAOi1vP_+c_qyX_BX+rsgG=-Azr9jE6GrNPxq1fExAJ5KgrnZWw@mail.gmail.com>
References: <20190602022546.16195-1-zyan@redhat.com>
         <20190602024316.GT17978@ZenIV.linux.org.uk>
         <c609c244-723f-7801-9de7-b2343e24c7ed@redhat.com>
         <CAOi1vP_+c_qyX_BX+rsgG=-Azr9jE6GrNPxq1fExAJ5KgrnZWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-06-25 at 20:42 +0200, Ilya Dryomov wrote:
> On Sun, Jun 2, 2019 at 9:21 AM Yan, Zheng <zyan@redhat.com> wrote:
> > On 6/2/19 10:43 AM, Al Viro wrote:
> > > On Sun, Jun 02, 2019 at 10:25:46AM +0800, Yan, Zheng wrote:
> > > > remove_session_caps() relies on __wait_on_freeing_inode(), to wait for
> > > > freezing inode to remove its caps. But VFS wakes freeing inode waiters

Is this a typo? Should that be "freeing inode to remove..." ?

> > > > before calling destroy_inode().
> > > 
> > > *blink*
> > > 
> > > Which tree is that against?
> > > 
> > > > -static void ceph_i_callback(struct rcu_head *head)
> > > > -{
> > > > -    struct inode *inode = container_of(head, struct inode, i_rcu);
> > > > -    struct ceph_inode_info *ci = ceph_inode(inode);
> > > > -
> > > > -    kfree(ci->i_symlink);
> > > > -    kmem_cache_free(ceph_inode_cachep, ci);
> > > > -}
> > > 
> > > ... is gone from mainline, and AFAICS not reintroduced in ceph tree.
> > > What am I missing here?
> > > 
> > 
> > Sorry, I should send it ceph-devel list
> 
> Hi Zheng,
> 
> I have rebased testing on top of 5.2-rc6 and dropped this patch.
> It conflicts with Al's cfa6d41263ca ("ceph: use ->free_inode()") in
> mainline and I don't see a new version.
> 
> Please take a look.
> 
> Thanks,
> 
>                 Ilya

I saw a new version of this patch in the ceph-client/testing branch, but
it was never sent to the list. Can you resend so it can be reviewed?
-- 
Jeff Layton <jlayton@kernel.org>

