Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6182DA12
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 12:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfE2KKx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 06:10:53 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33175 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfE2KKx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 06:10:53 -0400
Received: by mail-yb1-f196.google.com with SMTP id w127so584850yba.0
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 03:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fcy50gjziwU0Q6Jj7zHUgDIDRgHRE3zUkxc6fphSGr4=;
        b=HMdA4Zu683kH6NrsdU/wivbfcDjGhse1ZPJJRHWx5ZEQPJX/YJloakeGIBI5rLj3tm
         vac+TScrKK34+/vpM9eNtcS+XZFGX/6kLAhKiGTMi9yZliJ7+wjTltGpWfpgNwzbS/eo
         +XMulEsiPn2P/lNrCSA7evmNs8OYI8YZsKcIL1f6BVCIT9mrx5V/XTxRr9B1c25LQjVY
         ZsNFi157UZT+wtHv+UGxC86KntzarBTKT6mSxLt5et1w7Ri9pGUg/LAmUIlR+/7+dWjr
         KB7jN272OMKalLiuk7unVGyHQa74oG5YjJ0MDx2pAvnUGWxztQoRwiBVArVeO0XafJf0
         /dCA==
X-Gm-Message-State: APjAAAXQSp5GVrEtN4lMSs53uR3rOUSXZpRN/krI4yAJBZjHyMLprqLY
        m6aRGTkfKKWKqdB2MXAMp4G+Rg==
X-Google-Smtp-Source: APXvYqzQnZY02muGjCwielxi2Sl9uwjJS1tP0CvGEBYrJI8beJjU2GIWUiLCk1TtNfaOKqN7NKZF4g==
X-Received: by 2002:a5b:144:: with SMTP id c4mr13493967ybp.111.1559124652218;
        Wed, 29 May 2019 03:10:52 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-4F7.dyn6.twc.com. [2606:a000:1100:37d::4f7])
        by smtp.gmail.com with ESMTPSA id b184sm170331ywa.9.2019.05.29.03.10.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 03:10:51 -0700 (PDT)
Message-ID: <ac3f3632c1b2473cebe04d5da2ccdf325a7af0e2.camel@redhat.com>
Subject: Re: [PATCH 6/8] ceph: use READ_ONCE to access d_parent in RCU
 critical section
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, idryomov@redhat.com
Date:   Wed, 29 May 2019 06:10:50 -0400
In-Reply-To: <CAAM7YAkFTM=fkKcPSSdS6SVZZbzLRZ5p9_w_f2gNfgG7FVEQhg@mail.gmail.com>
References: <20190523081345.20410-1-zyan@redhat.com>
         <20190523081345.20410-6-zyan@redhat.com>
         <c16c31b59f33c9d881bdaacfdfeb0e629e682f94.camel@redhat.com>
         <CAAM7YAkFTM=fkKcPSSdS6SVZZbzLRZ5p9_w_f2gNfgG7FVEQhg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-05-29 at 10:17 +0800, Yan, Zheng wrote:
> On Tue, May 28, 2019 at 9:57 PM Jeff Layton <jlayton@redhat.com> wrote:
> > On Thu, 2019-05-23 at 16:13 +0800, Yan, Zheng wrote:
> > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > ---
> > >  fs/ceph/mds_client.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 60e8ddbdfdc5..870754e9d572 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -913,7 +913,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
> > >               struct inode *dir;
> > > 
> > >               rcu_read_lock();
> > > -             parent = req->r_dentry->d_parent;
> > > +             parent = READ_ONCE(req->r_dentry->d_parent);
> > 
> > Can we use rcu_dereference() instead?
> > 
> 
> d_parent has no __rcu mark. It will cause sparse warning.
> 
> Regards
> Yan, Zheng
> 

Good point.

> > >               dir = req->r_parent ? : d_inode_rcu(parent);
> > > 
> > >               if (!dir || dir->i_sb != mdsc->fsc->sb) {
> > > @@ -2131,8 +2131,8 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
> > >               if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
> > >                       dout("build_path path+%d: %p SNAPDIR\n",
> > >                            pos, temp);
> > > -             } else if (stop_on_nosnap && inode && dentry != temp &&
> > > -                        ceph_snap(inode) == CEPH_NOSNAP) {
> > > +             } else if (stop_on_nosnap && dentry != temp &&
> > > +                        inode && ceph_snap(inode) == CEPH_NOSNAP) {
> > 
> > ^^^ Unrelated delta?
> > 
> > >                       spin_unlock(&temp->d_lock);
> > >                       pos++; /* get rid of any prepended '/' */
> > >                       break;
> > > @@ -2145,7 +2145,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
> > >                       memcpy(path + pos, temp->d_name.name, temp->d_name.len);
> > >               }
> > >               spin_unlock(&temp->d_lock);
> > > -             temp = temp->d_parent;
> > > +             temp = READ_ONCE(temp->d_parent);
> > 
> > Better to use rcu_dereference() here.
> > 
> > >               /* Are we at the root? */
> > >               if (IS_ROOT(temp))
> > 

Reviewed-by: Jeff Layton <jlayton@redhat.com>

