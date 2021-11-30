Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D887A4635E7
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Nov 2021 14:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbhK3N6u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Nov 2021 08:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhK3N6r (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Nov 2021 08:58:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9947FC061574
        for <ceph-devel@vger.kernel.org>; Tue, 30 Nov 2021 05:55:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2A18CE16B4
        for <ceph-devel@vger.kernel.org>; Tue, 30 Nov 2021 13:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81533C53FC1;
        Tue, 30 Nov 2021 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638280524;
        bh=y8H42JdeV2F0vPlrQu2esH564mNQX/xkOo5jWXq/9jk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gGlYIczIekZwqrJpPqADgI+TrSiJ08u7G6eaQw+3a5XHVGoikhCGY13Tjk6XdNjdm
         0ECMxJkgGgzxEfSo0xq22app2sp0hyBiORfZwInfM0kJ8yfeLC2gP0yD7cTW2D18zN
         zRsILxzPCsr5wZ+YWQoCYBy2ZJE83iq4IzmiBPyclFLsEuLYK5ZCWrRy8U19bxAszu
         WxgBfhozMm1dUmbi01J6U4AzXT8GBgLqT1yhVzf4x6cbM8nIStJUhA1fK8uO1QJ28c
         mJjAFih4Zp7aMMHUoUrbcDIQf2NyZTLcbLjcaDGKzuS+4SluYcpm5qyzp1GaWpPQBo
         cQfaZDsFamOdA==
Message-ID: <7965c4707d595fd488eeed61731d5fc336c75e63.camel@kernel.org>
Subject: Re: [PATCH] ceph: initialize pathlen variable in reconnect_caps_cb
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org, dan.carpenter@oracle.com
Date:   Tue, 30 Nov 2021 08:55:22 -0500
In-Reply-To: <d14840f4-3ad8-55ce-480c-4d8cf3234893@redhat.com>
References: <20211130112034.2711318-1-xiubli@redhat.com>
         <41b05af2020a3cb345a16f5dfca15f6f5f41bfe4.camel@kernel.org>
         <d14840f4-3ad8-55ce-480c-4d8cf3234893@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-11-30 at 21:12 +0800, Xiubo Li wrote:
> On 11/30/21 8:07 PM, Jeff Layton wrote:
> > On Tue, 2021-11-30 at 19:20 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Silence the potential compiler warning.
> > > 
> > > Fixes: a33f6432b3a6 (ceph: encode inodes' parent/d_name in cap reconnect message)
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > Is this something we need to fix? AFAICT, there is no bug here.
> > 
> > In the case where ceph_mdsc_build_path returns an error, "path" will be
> > an ERR_PTR and then ceph_mdsc_free_path will be a no-op. If we do need
> > to take this, we should probably also credit Dan for finding it.
> > 
> As I remembered, when I was paying the gluster-block project, the 
> similar cases will always give a warning like this with code sanity 
> checking.
> 

Meh...ok.

I merged a slightly altered version of the patch into the testing
branch, revised the changelog and gave Dan reported-by credit. Please
take a look when you get a chance and let me know if anything is amiss.

Thanks,

> > > ---
> > >   fs/ceph/mds_client.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 87f20ed16c6e..2fc2b0a023e4 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -3711,7 +3711,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > >   	struct ceph_pagelist *pagelist = recon_state->pagelist;
> > >   	struct dentry *dentry;
> > >   	char *path;
> > > -	int pathlen, err;
> > > +	int pathlen = 0, err;
> > >   	u64 pathbase;
> > >   	u64 snap_follows;
> > >   
> > If we do take this, you can also get rid of the place where pathlen is
> > set in the !dentry case.
> > 
> 

-- 
Jeff Layton <jlayton@kernel.org>
