Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883692D3A9
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 04:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfE2CRU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 22:17:20 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43556 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfE2CRU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 22:17:20 -0400
Received: by mail-qk1-f193.google.com with SMTP id m14so437516qka.10
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 19:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FS5k+2ggisP+uTTHHHVUd4hjRXm6ij+hq5ZlXIPQjrc=;
        b=DXZ/5vfOPit8rdxphjvhdW2941lX+u4perf5qd9M8ubX0Q65A78ztfYlrdhCRfz338
         FnJ2jmo7gesQ4Wm0wMFdfEERO5ABD3O5IjmOB768oL4E9tapmhLJhb6HXks5Vwp/oRjz
         gSpDPabaMOkTLAgZTtLH15DG+JKoJuKfcMoF4i6bTZMA3hDm65ZwiYOghiSjsy/lyjuq
         2WsZEAramCSsZ3aOsyEltDOiP4+mJXN4nTP88cQz92J8wUkw6n4E3rwY/M9yUJ1OcaIS
         w4gLIsbUqI1Exz+m5KahUGW+CdVoQ7o4VOkVffWdjzUEnUnAo4CZN3g5cgFJT6NUfiau
         DWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FS5k+2ggisP+uTTHHHVUd4hjRXm6ij+hq5ZlXIPQjrc=;
        b=m5j5DxcEPAvSrsvCR+ouKf6bpm+Id9p/dV5ts+aYIIUdAVbEOGWiyWzPRAboGSgoG/
         h00AL8YwKkezoiHMAqNpMebdQ7nYHj2hBNUJBG4mOnWb6U45twfVoKN0UHXyZmeOg3QG
         +pawB/9Y44S0x+cH9lfWRiqX8vYwVYoxpjBiPHzKXPb/BATqigK2k8FSEVQgW8YHvGhj
         DX/SMDCYCT/252+UaXJjdf6bJiWhk6T3iSa4xwJ4+9jemky47o0PJ1W44BjL44eQ5tW7
         xtYQefhQGZwoaCL1Lw90SrWr71hSdwTaJJVvhfPyGb3+586VuIlL1Yo6hfAVAxyHZZdb
         4yUA==
X-Gm-Message-State: APjAAAUoK144hh+EcA6oXbhV1w9N1UV9leNWFytbehdTwQax1YW5jJ7g
        1qtv2uFwmhoGspvTXNVlZWyOumxX9fy+OTaV6Kg=
X-Google-Smtp-Source: APXvYqyOcJfXjLqoxCKZ09TTZyb5tUu9eOurZYaYh1IQEiUOtTa2A+59fpXCSNAPSCEbc/4+4COEFvJ04AeRvsu38Uk=
X-Received: by 2002:a05:620a:1186:: with SMTP id b6mr1493155qkk.271.1559096239218;
 Tue, 28 May 2019 19:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190523081345.20410-1-zyan@redhat.com> <20190523081345.20410-6-zyan@redhat.com>
 <c16c31b59f33c9d881bdaacfdfeb0e629e682f94.camel@redhat.com>
In-Reply-To: <c16c31b59f33c9d881bdaacfdfeb0e629e682f94.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 29 May 2019 10:17:07 +0800
Message-ID: <CAAM7YAkFTM=fkKcPSSdS6SVZZbzLRZ5p9_w_f2gNfgG7FVEQhg@mail.gmail.com>
Subject: Re: [PATCH 6/8] ceph: use READ_ONCE to access d_parent in RCU
 critical section
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, idryomov@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, May 28, 2019 at 9:57 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Thu, 2019-05-23 at 16:13 +0800, Yan, Zheng wrote:
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  fs/ceph/mds_client.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 60e8ddbdfdc5..870754e9d572 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -913,7 +913,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
> >               struct inode *dir;
> >
> >               rcu_read_lock();
> > -             parent = req->r_dentry->d_parent;
> > +             parent = READ_ONCE(req->r_dentry->d_parent);
>
> Can we use rcu_dereference() instead?
>

d_parent has no __rcu mark. It will cause sparse warning.

Regards
Yan, Zheng

> >               dir = req->r_parent ? : d_inode_rcu(parent);
> >
> >               if (!dir || dir->i_sb != mdsc->fsc->sb) {
> > @@ -2131,8 +2131,8 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
> >               if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
> >                       dout("build_path path+%d: %p SNAPDIR\n",
> >                            pos, temp);
> > -             } else if (stop_on_nosnap && inode && dentry != temp &&
> > -                        ceph_snap(inode) == CEPH_NOSNAP) {
> > +             } else if (stop_on_nosnap && dentry != temp &&
> > +                        inode && ceph_snap(inode) == CEPH_NOSNAP) {
>
> ^^^ Unrelated delta?
>
> >                       spin_unlock(&temp->d_lock);
> >                       pos++; /* get rid of any prepended '/' */
> >                       break;
> > @@ -2145,7 +2145,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
> >                       memcpy(path + pos, temp->d_name.name, temp->d_name.len);
> >               }
> >               spin_unlock(&temp->d_lock);
> > -             temp = temp->d_parent;
> > +             temp = READ_ONCE(temp->d_parent);
>
> Better to use rcu_dereference() here.
>
> >
> >               /* Are we at the root? */
> >               if (IS_ROOT(temp))
>
> --
> Jeff Layton <jlayton@redhat.com>
>
