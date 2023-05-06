Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73436F8FB7
	for <lists+ceph-devel@lfdr.de>; Sat,  6 May 2023 09:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjEFHNT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 6 May 2023 03:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjEFHNS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 6 May 2023 03:13:18 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9229EEA
        for <ceph-devel@vger.kernel.org>; Sat,  6 May 2023 00:13:16 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f195b164c4so17534535e9.1
        for <ceph-devel@vger.kernel.org>; Sat, 06 May 2023 00:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683357195; x=1685949195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RFsfhg1UnMmQxoZo1fKWlaw2p0mxSPU38cTqr28ATFI=;
        b=YH1P+tRFfHTOaXNDm+geERbT7NSVSVBGdHz3qIwkp+sPEY6eF7rnglHd/evfMOxEI9
         ZktpP4gIyAKJFLbIDj/89RvowtyMlM5feCY2XpKdDK9ztHVdOhjixgXzuosrN/tQWGeN
         0g/o/LPBWOqqGeRrxaZ3ZozMXi15UK4EneV3tZKlw7bj9lSX+Z/u/knAf39WZc7vrx3X
         4K4quo9AZBgyqjjGHFy6Unu5iKVqpovkxaIDZLwkhhf3J8NNH8yLCRbyGATFUeCCG6HB
         qIq5EbGYrpVmAwk4kfwv7DVw0ckZdIDfb9fTWpiPWXwSgX6uWQTUcMY0AePzE7VH9acq
         iVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683357195; x=1685949195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RFsfhg1UnMmQxoZo1fKWlaw2p0mxSPU38cTqr28ATFI=;
        b=LiSwLGRUvBvsGgimXOXn96YMBLSWn/AMkOIvv4mb2nPHGyqjLGCKoQg1UKem8TKaUB
         ubP3FEXyeo0AIcWL9syV/rsli00Io7x6bwnpsX71VKGPQZi5+FuXlddHqANqtxTzeVy9
         qIKKDYd7v15SfCQ0d4UuQTuPT8Tsl937mk/TBofaoj2ytey7lgNGETHyltrR9CVun6Is
         Ng0Biq0vAv1DXVJhYgZTLYSX0N5+v1zxlrbm2v/UXwQGAjngZ2pUrVVICKMoIvCz5ycy
         oZGyka43bjhR+TXl++dKRzwXDQpj4Y57/KOxRI9PhUgjHXGPGfUan+NfwdCNUawXWo86
         3skg==
X-Gm-Message-State: AC+VfDyju5lJ2/k0JT6t7KGiedXkzLsr5ElHeXpoCxSYMlJjSzkjs8hI
        4Jb/wT0VMQkxHs3v+83v7jH9sQ==
X-Google-Smtp-Source: ACHHUZ4LlLXPF+4t0ipMyVl6zDrzBWUExGWgqLvQVML8OPdmJKIp9jmMgxuJIDKmCUmd/BqOjAjI6g==
X-Received: by 2002:a1c:720f:0:b0:3f3:3063:f904 with SMTP id n15-20020a1c720f000000b003f33063f904mr2692372wmc.31.1683357195078;
        Sat, 06 May 2023 00:13:15 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g22-20020a7bc4d6000000b003f049a42689sm9895503wmk.25.2023.05.06.00.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 May 2023 00:13:13 -0700 (PDT)
Date:   Sat, 6 May 2023 10:13:06 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [bug report] ceph: fix potential use-after-free bug when
 trimming caps
Message-ID: <43a81ea0-c24f-4a27-a313-0da1abd41004@kili.mountain>
References: <9e074e4b-9519-42e2-819a-7089564d6158@kili.mountain>
 <937dc7c7-1907-5511-d691-7f531e72bd8f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <937dc7c7-1907-5511-d691-7f531e72bd8f@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, May 06, 2023 at 09:32:30AM +0800, Xiubo Li wrote:
> Hi Dan,
> 
> On 5/5/23 17:21, Dan Carpenter wrote:
> > Hello Xiubo Li,
> > 
> > The patch aaf67de78807: "ceph: fix potential use-after-free bug when
> > trimming caps" from Apr 19, 2023, leads to the following Smatch
> > static checker warning:
> > 
> > 	fs/ceph/mds_client.c:3968 reconnect_caps_cb()
> > 	warn: missing error code here? '__get_cap_for_mds()' failed. 'err' = '0'
> > 
> > fs/ceph/mds_client.c
> >      3933 static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
> >      3934 {
> >      3935         union {
> >      3936                 struct ceph_mds_cap_reconnect v2;
> >      3937                 struct ceph_mds_cap_reconnect_v1 v1;
> >      3938         } rec;
> >      3939         struct ceph_inode_info *ci = ceph_inode(inode);
> >      3940         struct ceph_reconnect_state *recon_state = arg;
> >      3941         struct ceph_pagelist *pagelist = recon_state->pagelist;
> >      3942         struct dentry *dentry;
> >      3943         struct ceph_cap *cap;
> >      3944         char *path;
> >      3945         int pathlen = 0, err = 0;
> >      3946         u64 pathbase;
> >      3947         u64 snap_follows;
> >      3948
> >      3949         dentry = d_find_primary(inode);
> >      3950         if (dentry) {
> >      3951                 /* set pathbase to parent dir when msg_version >= 2 */
> >      3952                 path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
> >      3953                                             recon_state->msg_version >= 2);
> >      3954                 dput(dentry);
> >      3955                 if (IS_ERR(path)) {
> >      3956                         err = PTR_ERR(path);
> >      3957                         goto out_err;
> >      3958                 }
> >      3959         } else {
> >      3960                 path = NULL;
> >      3961                 pathbase = 0;
> >      3962         }
> >      3963
> >      3964         spin_lock(&ci->i_ceph_lock);
> >      3965         cap = __get_cap_for_mds(ci, mds);
> >      3966         if (!cap) {
> >      3967                 spin_unlock(&ci->i_ceph_lock);
> > --> 3968                 goto out_err;
> > 
> > Set an error code?
> 
> This was intended, the 'err' was initialized as '0' in line 3945.
> 
> It's no harm to skip this _cb() for current cap, so just succeeds it.
> 

Smatch considers it intentional of the "ret = 0;" assignment is within
4 or 5 (I forget) lines of the goto.  Otherwise adding a comment would
help reviewers.

regards,
dan carpenter

