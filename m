Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB53508A6C
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Apr 2022 16:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379613AbiDTOQQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Apr 2022 10:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379493AbiDTOP5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Apr 2022 10:15:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D8A746666
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 07:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650463738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7G1e0E3S3FJYkMOOfdMzv3C6ceLCisdbjmZ5gTTANa8=;
        b=S+bQ94zvhIaAR9+j3w33YgEd7uz1wL8Op9amhjSWznQN+iF746EqQOOwTlIiqkTKKi4m1F
        GX2GLRXevQscLTaxihq32ucTEFI3gOflYj4AWS3gS0ucCX429DZAaIeAwesqBSTXy3S874
        02Ug7TVf38iirSNB8LMSwueEh+SFxHw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-2sWySSAyOCG6YgoZbDgyNg-1; Wed, 20 Apr 2022 10:08:56 -0400
X-MC-Unique: 2sWySSAyOCG6YgoZbDgyNg-1
Received: by mail-lf1-f72.google.com with SMTP id o4-20020a056512050400b00471c0de51efso500398lfb.5
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 07:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7G1e0E3S3FJYkMOOfdMzv3C6ceLCisdbjmZ5gTTANa8=;
        b=Pc7RT9uFT/wnkSTDVzkKXW4qhcZR/abmvVC8U7kguxIWS5stgT75tuzA9cnzUCqVYr
         PC5Ri4vnSOEnViZg40sWiOEqFDz/QiYDjOkuLqdQH8IFH9C/RRX583935pIGnJT/jBT/
         fcCakF/Y+cVdufTT8OPGY9MZdvgTji+QfOXIdTuwlmEf1QP9G9Agynnmr7qserPjXl79
         m1f9KZTPPweDKG4PkQDnKwD7Xqsi8svNrBwVAvoZJYahxwXgkeASqZTMtTZX0eUGjYeH
         r3tqCyNI6IRXWRczlWRGHDOMoaOiLNJ3HppbPI/c8qygibpdp/1qnnTGlDi2GDyByzXS
         DyHg==
X-Gm-Message-State: AOAM533XRRpL1Fca0BUEhHs7r/Ugdi9emay82wbnfJqcsLAHds10U5qB
        GRNzX+60ZXVX7cnkOCJtRNYIJ0v/Lkjnw8BqJL1+genvPhKE9pDLu8tUwC/HJTZ9K4MVcc3WOMM
        Z9rlDfpTzhqtJCcvLqm4a5uj8lSmNqpbBWP9oGg==
X-Received: by 2002:a19:ac42:0:b0:448:1f15:4b18 with SMTP id r2-20020a19ac42000000b004481f154b18mr14722388lfc.32.1650463734573;
        Wed, 20 Apr 2022 07:08:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRxXSXOPZpArl8DhVOMimesGgeQ3uzuyEFaEEkKwwhaQISFg1uweMwcvSwVvnv33S6Eikg2w6CFlO8tfw3L34=
X-Received: by 2002:a19:ac42:0:b0:448:1f15:4b18 with SMTP id
 r2-20020a19ac42000000b004481f154b18mr14722361lfc.32.1650463734226; Wed, 20
 Apr 2022 07:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220420052404.1144209-1-xiubli@redhat.com> <5b6832315f8561010bb2a7dd93638752ebf8166b.camel@kernel.org>
In-Reply-To: <5b6832315f8561010bb2a7dd93638752ebf8166b.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 20 Apr 2022 07:08:43 -0700
Message-ID: <CAJ4mKGb+ru__H24Z2vONJ+Q3np5ix+mqju7iYBayrAwZG1CxAQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: disable updating the atime since cephfs won't
 maintain it
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 20, 2022 at 6:57 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2022-04-20 at 13:24 +0800, Xiubo Li wrote:
> > Since the cephFS makes no attempt to maintain atime, we shouldn't
> > try to update it in mmap and generic read cases and ignore updating
> > it in direct and sync read cases.
> >
> > And even we update it in mmap and generic read cases we will drop
> > it and won't sync it to MDS. And we are seeing the atime will be
> > updated and then dropped to the floor again and again.
> >
> > URL: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/VSJM7T4CS5TDRFF6XFPIYMHP75K73PZ6/
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/addr.c  | 1 -
> >  fs/ceph/super.c | 1 +
> >  2 files changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index aa25bffd4823..02722ac86d73 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1774,7 +1774,6 @@ int ceph_mmap(struct file *file, struct vm_area_struct *vma)
> >
> >       if (!mapping->a_ops->readpage)
> >               return -ENOEXEC;
> > -     file_accessed(file);
> >       vma->vm_ops = &ceph_vmops;
> >       return 0;
> >  }
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index e6987d295079..b73b4f75462c 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -1119,6 +1119,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
> >       s->s_time_gran = 1;
> >       s->s_time_min = 0;
> >       s->s_time_max = U32_MAX;
> > +     s->s_flags |= SB_NODIRATIME | SB_NOATIME;
> >
> >       ret = set_anon_super_fc(s, fc);
> >       if (ret != 0)
>
> (cc'ing Greg since he claimed this...)

Hmm? I don't think I've been in any atime discussions in years...

>
> I confess, I've never dug into the MDS code that should track atime, but
> I'm rather surprised that the MDS just drops those updates onto the
> floor.
>
> It's obviously updated when the mtime changes. The SETATTR operation
> allows the client to set the atime directly, and there is an "atime"
> slot in the cap structure that does get populated by the client. I guess
> though that it has never been 100% clear what cap the atime should be
> governed by so maybe it just always ignores that field?
>
> Anyway, I've no firm objection to this since no one in their right mind
> should use the atime anyway, but you may see some complaints if you just
> turn it off like this. There are some applications that use it.
> Hopefully no one is running those on ceph.
>
> It would be nice to document this somewhere as well -- maybe on the ceph
> POSIX conformance page?
>
>     https://docs.ceph.com/en/latest/cephfs/posix/
>
> --
> Jeff Layton <jlayton@kernel.org>
>

