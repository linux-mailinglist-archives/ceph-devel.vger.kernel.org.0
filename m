Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F5F3CC337
	for <lists+ceph-devel@lfdr.de>; Sat, 17 Jul 2021 14:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhGQMaW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 17 Jul 2021 08:30:22 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:44408
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S229471AbhGQMaP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 17 Jul 2021 08:30:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=bw/P2ct3q0JI7DPI1DUJAEXItR5PHJsDmCVe
        /ICZLH8=; b=lVd2LurH35u1VUDdDEs+HE/FzxWjajggdOgLz4W7HQwgh2Ffy9+U
        gzaCp/AOZDI+Z0ooiigtFbZZcBv/LwghJu3KzZjFg74/MbA49OvfxKrJk/VyHIsf
        HkcJoaBnSThjR314Hc3oevPhANy8Rbc2+InfXF34LGU9JKx+EWbkE98=
Received: by ajax-webmail-app1 (Coremail) ; Sat, 17 Jul 2021 20:26:45 +0800
 (GMT+08:00)
X-Originating-IP: [39.144.44.130]
Date:   Sat, 17 Jul 2021 20:26:45 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Xiyu Yang" <xiyuyang19@fudan.edu.cn>
To:     "Jeff Layton" <jlayton@kernel.org>
Cc:     "Ilya Dryomov" <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        "Xin Tan" <tanxin.ctf@gmail.com>,
        "Yejune Deng" <yejune.deng@gmail.com>
Subject: Re: Re: [PATCH] ceph: Convert from atomic_t to refcount_t on
 ceph_snap_realm->nref
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20200917(8294e55f) Copyright (c) 2002-2021 www.mailtech.cn fudan.edu.cn
In-Reply-To: <2e5088eb8df4db5ea4d9c9f2862fc19c3bf186d4.camel@kernel.org>
References: <1626516381-40440-1-git-send-email-xiyuyang19@fudan.edu.cn>
 <2e5088eb8df4db5ea4d9c9f2862fc19c3bf186d4.camel@kernel.org>
X-SendMailWithSms: false
Content-Transfer-Encoding: 7bit
X-CM-CTRLDATA: k2MTk2Zvb3Rlcl90eHQ9NDY0OToxMA==
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <702aa2de.980b.17ab46ee99b.Coremail.xiyuyang19@fudan.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: XAUFCgD3_0+FzPJgLf58AA--.13216W
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/1tbiAQ8FAVKp4xL5+gAAsD
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thank you for pointing out the problem in the patch. I cannot find an unique refcount API work like atomic_inc_return, thus I chose two APIs to play a similar role and forgot the potential racy case. So are you have a better choice to help this refcount type convertation?


> -----Original Messages-----
> From: "Jeff Layton" <jlayton@kernel.org>
> Sent Time: 2021-07-17 19:21:40 (Saturday)
> To: "Xiyu Yang" <xiyuyang19@fudan.edu.cn>, "Ilya Dryomov" <idryomov@gmail.com>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
> Cc: yuanxzhang@fudan.edu.cn, "Xin Tan" <tanxin.ctf@gmail.com>, "Yejune Deng" <yejune.deng@gmail.com>
> Subject: Re: [PATCH] ceph: Convert from atomic_t to refcount_t on ceph_snap_realm->nref
> 
> On Sat, 2021-07-17 at 18:06 +0800, Xiyu Yang wrote:
> > refcount_t type and corresponding API can protect refcounters from
> > accidental underflow and overflow and further use-after-free situations.
> > 
> > Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> > Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> > ---
> >  fs/ceph/snap.c  | 15 ++++++++-------
> >  fs/ceph/super.h |  3 ++-
> >  2 files changed, 10 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index 4ac0606dcbd4..d4ec9c5118bd 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -68,14 +68,15 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
> >  	lockdep_assert_held(&mdsc->snap_rwsem);
> >  
> >  	dout("get_realm %p %d -> %d\n", realm,
> > -	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
> > +	     refcount_read(&realm->nref), refcount_read(&realm->nref)+1);
> >  	/*
> >  	 * since we _only_ increment realm refs or empty the empty
> >  	 * list with snap_rwsem held, adjusting the empty list here is
> >  	 * safe.  we do need to protect against concurrent empty list
> >  	 * additions, however.
> >  	 */
> > -	if (atomic_inc_return(&realm->nref) == 1) {
> > +	refcount_inc(&realm->nref);
> > +	if (refcount_read(&realm->nref) == 1) {
> 
> The above is potentially racy as you've turned a single atomic operation
> into two. Another task could come in and increment or decrement
> realm->nref just after your recount_inc but before the refcount_read,
> and then the read would show the wrong result.
> 
> FWIW, Yejune Deng (cc'ed) proposed a very similar patch a few months ago
> that caused this regression:
> 
>     https://tracker.ceph.com/issues/50281
> 
> >  		spin_lock(&mdsc->snap_empty_lock);
> >  		list_del_init(&realm->empty_item);
> >  		spin_unlock(&mdsc->snap_empty_lock);
> > @@ -121,7 +122,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
> >  	if (!realm)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > -	atomic_set(&realm->nref, 1);    /* for caller */
> > +	refcount_set(&realm->nref, 1);    /* for caller */
> >  	realm->ino = ino;
> >  	INIT_LIST_HEAD(&realm->children);
> >  	INIT_LIST_HEAD(&realm->child_item);
> > @@ -209,8 +210,8 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
> >  	lockdep_assert_held_write(&mdsc->snap_rwsem);
> >  
> >  	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> > -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> > -	if (atomic_dec_and_test(&realm->nref))
> > +	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
> > +	if (refcount_dec_and_test(&realm->nref))
> >  		__destroy_snap_realm(mdsc, realm);
> >  }
> >  
> > @@ -221,8 +222,8 @@ void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
> >  			 struct ceph_snap_realm *realm)
> >  {
> >  	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> > -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> > -	if (!atomic_dec_and_test(&realm->nref))
> > +	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
> > +	if (!refcount_dec_and_test(&realm->nref))
> >  		return;
> >  
> >  	if (down_write_trylock(&mdsc->snap_rwsem)) {
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 6b6332a5c113..3abb00d7a0eb 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -2,6 +2,7 @@
> >  #ifndef _FS_CEPH_SUPER_H
> >  #define _FS_CEPH_SUPER_H
> >  
> > +#include <linux/refcount.h>
> >  #include <linux/ceph/ceph_debug.h>
> >  
> >  #include <asm/unaligned.h>
> > @@ -859,7 +860,7 @@ struct ceph_readdir_cache_control {
> >  struct ceph_snap_realm {
> >  	u64 ino;
> >  	struct inode *inode;
> > -	atomic_t nref;
> > +	refcount_t nref;
> >  	struct rb_node node;
> >  
> >  	u64 created, seq;
> 
> -- 
> Jeff Layton <jlayton@kernel.org>






