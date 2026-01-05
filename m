Return-Path: <ceph-devel+bounces-4254-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B679CF5C6E
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 23:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B8B1305A762
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 22:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF942EC08C;
	Mon,  5 Jan 2026 22:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YNaqGhsd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBFD26F2AF
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 22:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767650978; cv=none; b=H/BNsMCNxNbyKx6fzN9J3QTQD8i7TDR2QzmAqz+BaOtnAOwn4hN/fjsYy5s5skp/gY/tgfZIr2odHpcGR9GgCzUE10g3LKkQUHQZVZYa7juiV3dwgQLGMhoxFPllkVvmhZMIxcOt9rOQLRmislM7xi23Uh9r3APktvg/LqcNVn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767650978; c=relaxed/simple;
	bh=oRSqcf7zYJbfwP4eAHctIOINK2cHZX29WJYjoHRIho0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EZRYyxbbfcK0e58aeS0baDeQrRvYRWUTC22qaOsbwVxJjtTsB5dKP0FzNoaWLfnaWQbGKKyASVdzA/dmzVqiaaB83bDsGb7OZGWiWKc//zmFTz0jVIDOsGXsQTKc/vyqXHjRSTXWt5U2N0YKl1ReYTvzJi6jRSURF2SnL1/K2mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YNaqGhsd; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a0c20ee83dso4344455ad.2
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 14:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767650977; x=1768255777; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPYmdT7/bg5FjFA61gbfMWIjzcKvYlnVvxhYYGeUuUg=;
        b=YNaqGhsdzA5k8zf4/swqinjYRuiadYUejqc4edkHNmOMudPG25mxK3D8Iksw5BfNZx
         GtWYJLjvFDG8lyytubrhXQvb8C+WHwEUwMvz6r/s+Jg7ZhxKiTqwU2CzSq61k9qihslH
         Wno5XXN3bBkUWSn152tB0H9nS5XZ1sUh+Qzt1mmxmycOc45MZqqjdBrDD5yBMXAztZbY
         wFYNCYXVQ4drl64rQSLPqaEz4KXSoVCsNvBxa1XmyihmcWwhLqPBVxv3Md0bKpdzEAEQ
         JtEtNvHQ8Txm2eJldpq9ftH1XTBi4bcOUYXgDPYmgnahXy37fXht4xid6hz72Wh3upuf
         kytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767650977; x=1768255777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WPYmdT7/bg5FjFA61gbfMWIjzcKvYlnVvxhYYGeUuUg=;
        b=LmVn06wN8M2Gk9hDe0sK/TKl8CaA21xMg6Fw/eOQr+53VFjdJrqEfBgmnqdZypoW5Q
         YONXnyHKbQ6tNjfV5h4QK2sqJyN6HTB0H7KHM4FJqxDeHL6H13KCC2t0i3uQIxuK75aJ
         jKr9AHdhnmasrozYXmXn5Y8K5FjGType+B0VxyJkEuzt5AMkxG/mPQeD1RfNrbaR8Sc7
         2Op68LcJqvm1QWoaB/pEBePNv98NA9CXeTfFqK8vEC1K8q4sSxulgCvLTY1/MmSvHeze
         bYE7en6QrkQ3nln9gA/FoUBQzdzqjr9biCx6PNzlEewYsICOuAGbYNIMLN3w80/uiWoq
         XAkg==
X-Gm-Message-State: AOJu0YxPQRpjL0KbCNWwEvR6uJHTBiLOeFOzCeLZ0st+QkPGaxJNLrY5
	aklF09tTCDcEFUEuvDpmzByG92t5zLgh/Gzfd90s/ddXUcr6CNvNOQ/6ySfVleiFoF0pLhSPqbn
	WaZq8DB3c/Q0PaLueELpRXlzu01v45ggT5HrP
X-Gm-Gg: AY/fxX7fFnMEUh1HAaBAGZL0F0cdzNxZCeHHrPp8+fBk4hcA9RIo5OqOg8c4wQZkum2
	Irw0WqLn2N+KRjFI+uf4X2IaHf5j9bbqS9Dyz5Li2P7RsQ8UKW3TW4Q+zPlXoBNTrs/ccNiOUAj
	X1Dea1n5Afe46z55m0ZK8iX7G/6qESX64Dhb57ea+RmK2g6d1uTypR4jiomkwyns/Y0dN2ju08v
	3Cbfkf8I0a8DL0glCkQ3GII8IS5sDZAU5tHPZg1tdwdcyxpHka0ZKwbJPGUaB2vRia8F9U=
X-Google-Smtp-Source: AGHT+IF8aMkU3/9M7ff2nO1vxk8GdUPSvg8AJRCip099fy/Rko1jXRK84LMgnxReajaSv3IUl9HKvijdeS8zpQEK+uo=
X-Received: by 2002:a05:7022:425:b0:11b:d561:bc10 with SMTP id
 a92af1059eb24-121f18f9ed6mr812797c88.41.1767650976498; Mon, 05 Jan 2026
 14:09:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231135845.4044168-1-idryomov@gmail.com> <0c55fc3a434624d4eb67babee7108e23e7774cff.camel@ibm.com>
In-Reply-To: <0c55fc3a434624d4eb67babee7108e23e7774cff.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 5 Jan 2026 23:09:24 +0100
X-Gm-Features: AQt7F2oAWAZSSgBhqNdU-9K5Ne21GL2uze6eNt2B5THf4--xzN0aQgHDbJU1dKo
Message-ID: <CAOi1vP97PK23jGxtFBDbqUoNDp_ptbHRXgQvdPDxrk78htKfLQ@mail.gmail.com>
Subject: Re: [PATCH] libceph: return the handler error from mon_handle_auth_done()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 8:37=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Wed, 2025-12-31 at 14:58 +0100, Ilya Dryomov wrote:
> > Currently any error from ceph_auth_handle_reply_done() is propagated
> > via finish_auth() but isn't returned from mon_handle_auth_done().  This
> > results in higher layers learning that (despite the monitor considering
> > us to be successfully authenticated) something went wrong in the
> > authentication phase and reacting accordingly, but msgr2 still trying
> > to proceed with establishing the session in the background.  In the
> > case of secure mode this can trigger a WARN in setup_crypto() and later
> > lead to a NULL pointer dereference inside of prepare_auth_signature().
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  net/ceph/mon_client.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> > index c227ececa925..fa8dd2a20f7d 100644
> > --- a/net/ceph/mon_client.c
> > +++ b/net/ceph/mon_client.c
> > @@ -1417,7 +1417,7 @@ static int mon_handle_auth_done(struct ceph_conne=
ction *con,
> >       if (!ret)
> >               finish_hunting(monc);
> >       mutex_unlock(&monc->mutex);
> > -     return 0;
> > +     return ret;
> >  }
> >
> >  static int mon_handle_auth_bad_method(struct ceph_connection *con,
>
> Makes sense to me. Looks good.
>
> Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> As far as I can see, we have the same strange implementation pattern in
> mon_handle_auth_bad_method() [1]:
>
> static int mon_handle_auth_bad_method(struct ceph_connection *con,
>                                       int used_proto, int result,
>                                       const int *allowed_protos, int prot=
o_cnt,
>                                       const int *allowed_modes, int mode_=
cnt)
> {
>         struct ceph_mon_client *monc =3D con->private;
>         bool was_authed;
>
>         mutex_lock(&monc->mutex);
>         WARN_ON(!monc->hunting);
>         was_authed =3D ceph_auth_is_authenticated(monc->auth);
>         ceph_auth_handle_bad_method(monc->auth, used_proto, result,
>                                     allowed_protos, proto_cnt,
>                                     allowed_modes, mode_cnt);
>         finish_auth(monc, -EACCES, was_authed);
>         mutex_unlock(&monc->mutex);
>         return 0;
> }
>
> If we don't return error code at all, then why declaration of function ex=
pects
> of error code returning? Should we exchange returning data type on void?

Hi Slava,

mon_handle_auth_bad_method() implements a msgr2 callout, just like
mon_handle_auth_done() does.  The handler may need to e.g. allocate
memory or in general do any number of things that could fail, so the
interface must provide a way to signal such failures to the messenger
to ensure that it doesn't try to proceed any further with the session.
Theoretically the return type could be downgraded to bool, but
definitely not to void.

Thanks,

                Ilya

