Return-Path: <ceph-devel+bounces-4266-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7316CFADA0
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 21:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 576033053A2A
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 19:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2F833EB0B;
	Tue,  6 Jan 2026 19:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBlILWIL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F0333F8B3
	for <ceph-devel@vger.kernel.org>; Tue,  6 Jan 2026 19:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728835; cv=none; b=OpugX0ISqFrsdqas+dTtWbi7ZXiSP5Z/ckMxqslINUJPPLJRpu03eLSV1Ku0PluViJ28rWOl154ipQaYTuUhHrqMJvC8zO6ip3nv6dR0wUzvmK7UcbOVAvt5EHvFExotGq6UJ0CqxAQJWRhlEeq58gedWnNv0plM5IRqWN7rF+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728835; c=relaxed/simple;
	bh=ILXA6kGNdK0AI2aMAWTuRv8djKFqV8ifp8wZl+5Vpjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MVdt2XQFsdhhQshZNXW1jgU96wgKLpf/2ieVODuBLpm9zGinZessQRLqw3OFrgQW/VYGXcC4uJv/EA1huPUV3ZlxNuAP6lM7FrPUshO1OEiRVF3TG425KQ7tQVXnkajf6Pz8F8xAsXJPk6RKXSCUWJsVLdfVon4neMo8XVI3iqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBlILWIL; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-121bf277922so848785c88.0
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jan 2026 11:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767728832; x=1768333632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1UiK6s1II+O4ak9r6TBCNK/ydyr827+wB4kZqECupmA=;
        b=UBlILWILkCRTLTyaOzyAUHNh19bEHhDJ9sPp29G2oBeTPe8dfxQXY82lsEMzVhQQQL
         uJs9Nrzl++gRcIkJhT70+Oo/Hl/ZDUuK4KHPUceGBni6a7YLxl9s7xwjPbbUwF7hNUw4
         +hO8Xsdt2aofuF5l3kZW9w2Ed1v8Sns2nfCs+t2rOrkQ96GyRjXWm0t+SKCTv9Lg5xaS
         P/vPxYhPkI07F2W429bmjdnMdf10d6NM5c3MWVKFA1OZmEoCujFltx2uRvjr6jEcjBnx
         bG31rpf5DuTuRPJYh+tBdAzeQmYvkMuI5r8WRZGgLUahnuYx+t9Hkk66W5iHmZ5pfzKR
         Yytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767728832; x=1768333632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1UiK6s1II+O4ak9r6TBCNK/ydyr827+wB4kZqECupmA=;
        b=vuNlWdRUTKem1OHVNkqsWYLwQIZUE/B0m1YD9ZILDtXQmY2JgLFSNxfLhulSuRdf34
         NQn7RWdKGhUFYmkfeDcVUvDp3I4+D7VI7kvrs92J8r9eY1DY4M8mWOu63YzwFTOUnL7q
         +gJ6QLjHnH1di91IbAfrquRFH1Kw7S4RKhll5LoyhyMyfVOjjNL/nhukt3sdxCRXB/Gc
         utpNxZT1VCU6zjUiZIPwaI2FWBuVQcARR52gI9hpPCGfenY2c+A1oUhFQEVMRqLTRNkD
         b6ZMWZZYrppp4RbPJUMHssBeF1qqr8Q0h4RMwhWlCMd3+qhb0/VOAp8u/nKNaBqReGs0
         fZ3Q==
X-Gm-Message-State: AOJu0YxM8uBsdZ6EgfjPIQG9+ee7P7MWfG2bWl727rzvY797Vash64/U
	HQQfNd0OLtTH4+s/f65syrv6Q0pM/78DhlS8gEV083qvAhUdYEOXN6Yvot6kB4cmZu3KP3/cvXj
	wlKeXE0W1jIbnTfhl4lM2PYbhJEcQDKw=
X-Gm-Gg: AY/fxX6Klqd98XL8gQtVs8OkpOdtgOXhAKwRPgKx2I2QyXz1iFrztT7bYrqe4syXfEa
	7cWJjUqPDZON8v5qIen9WpI2ArcYx0JHYQ2Qctdbor1arc3TM/RpOc3GrissK3eEVgXd4Q3hrJ5
	oZfRpQuwI0MFsOd/agugxX1el2ywYisXPJrXs3GeRDvF7dZPeRIG6VhD8OEcS0kMl6qPIWLBoFW
	AqrjFhYYKdV30y/GkNgxzLQQppHBJ7Ps1PFx7pToBxmvklXigDLGGi6GHYkPwA7GDsk0Xg=
X-Google-Smtp-Source: AGHT+IEx26um2r8qP1mJi2NpTjFrsg7wENr+WnisUr/007cGnUd4HjXM260XfcSzjJMU/yZ+xFN2n1RAFMhH0KdhLok=
X-Received: by 2002:a05:7022:628a:b0:11b:a892:80b4 with SMTP id
 a92af1059eb24-121f8afc1cdmr83031c88.5.1767728832055; Tue, 06 Jan 2026
 11:47:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231135845.4044168-1-idryomov@gmail.com> <0c55fc3a434624d4eb67babee7108e23e7774cff.camel@ibm.com>
 <CAOi1vP97PK23jGxtFBDbqUoNDp_ptbHRXgQvdPDxrk78htKfLQ@mail.gmail.com> <b9f11d0303c9b682ab35e076697f199f1a114613.camel@ibm.com>
In-Reply-To: <b9f11d0303c9b682ab35e076697f199f1a114613.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 6 Jan 2026 20:46:59 +0100
X-Gm-Features: AQt7F2rlzvMJyU9TyOq1HUVD3NDl3TexgMb0qcc-whQyok0cGk0nXE-V0A7Mbsw
Message-ID: <CAOi1vP8ehjwzo5iRUKHkXQdQNLP60ny84pxxXJMkKLyFYNz9ow@mail.gmail.com>
Subject: Re: [PATCH] libceph: return the handler error from mon_handle_auth_done()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 11:36=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Mon, 2026-01-05 at 23:09 +0100, Ilya Dryomov wrote:
> > On Mon, Jan 5, 2026 at 8:37=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyk=
o@ibm.com> wrote:
> > >
> > > On Wed, 2025-12-31 at 14:58 +0100, Ilya Dryomov wrote:
> > > > Currently any error from ceph_auth_handle_reply_done() is propagate=
d
> > > > via finish_auth() but isn't returned from mon_handle_auth_done().  =
This
> > > > results in higher layers learning that (despite the monitor conside=
ring
> > > > us to be successfully authenticated) something went wrong in the
> > > > authentication phase and reacting accordingly, but msgr2 still tryi=
ng
> > > > to proceed with establishing the session in the background.  In the
> > > > case of secure mode this can trigger a WARN in setup_crypto() and l=
ater
> > > > lead to a NULL pointer dereference inside of prepare_auth_signature=
().
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > > > ---
> > > >  net/ceph/mon_client.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> > > > index c227ececa925..fa8dd2a20f7d 100644
> > > > --- a/net/ceph/mon_client.c
> > > > +++ b/net/ceph/mon_client.c
> > > > @@ -1417,7 +1417,7 @@ static int mon_handle_auth_done(struct ceph_c=
onnection *con,
> > > >       if (!ret)
> > > >               finish_hunting(monc);
> > > >       mutex_unlock(&monc->mutex);
> > > > -     return 0;
> > > > +     return ret;
> > > >  }
> > > >
> > > >  static int mon_handle_auth_bad_method(struct ceph_connection *con,
> > >
> > > Makes sense to me. Looks good.
> > >
> > > Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> > >
> > > As far as I can see, we have the same strange implementation pattern =
in
> > > mon_handle_auth_bad_method() [1]:
> > >
> > > static int mon_handle_auth_bad_method(struct ceph_connection *con,
> > >                                       int used_proto, int result,
> > >                                       const int *allowed_protos, int =
proto_cnt,
> > >                                       const int *allowed_modes, int m=
ode_cnt)
> > > {
> > >         struct ceph_mon_client *monc =3D con->private;
> > >         bool was_authed;
> > >
> > >         mutex_lock(&monc->mutex);
> > >         WARN_ON(!monc->hunting);
> > >         was_authed =3D ceph_auth_is_authenticated(monc->auth);
> > >         ceph_auth_handle_bad_method(monc->auth, used_proto, result,
> > >                                     allowed_protos, proto_cnt,
> > >                                     allowed_modes, mode_cnt);
> > >         finish_auth(monc, -EACCES, was_authed);
> > >         mutex_unlock(&monc->mutex);
> > >         return 0;
> > > }
> > >
> > > If we don't return error code at all, then why declaration of functio=
n expects
> > > of error code returning? Should we exchange returning data type on vo=
id?
> >
> > Hi Slava,
> >
> > mon_handle_auth_bad_method() implements a msgr2 callout, just like
> > mon_handle_auth_done() does.  The handler may need to e.g. allocate
> > memory or in general do any number of things that could fail, so the
> > interface must provide a way to signal such failures to the messenger
> > to ensure that it doesn't try to proceed any further with the session.
> > Theoretically the return type could be downgraded to bool, but
> > definitely not to void.
> >
>
> Maybe, do we need to add the comment that explaining all of this?

This isn't specific to the messenger, so I don't think so.  When one
encounters a method with a bunch of parameters or a return value that
doesn't immediately make sense, a very common explanation is that the
method implements an interface and that the given implementation just
happens to not depend on those parameters or always succeed, etc.  The
interface is usually wired up in the same file and is trivial to look
up by searching for the name of the method:

static const struct ceph_connection_operations osd_con_ops =3D {
        ...
        .get_auth_request =3D osd_get_auth_request,
        .handle_auth_reply_more =3D osd_handle_auth_reply_more,
        .handle_auth_done =3D osd_handle_auth_done,
        .handle_auth_bad_method =3D osd_handle_auth_bad_method,
};

From there one can check out the interface itself:

/*
 * Ceph defines these callbacks for handling connection events.
 */
struct ceph_connection_operations {
        ...
        /* msgr2 authentication exchange */
        int (*get_auth_request)(struct ceph_connection *con,
                                void *buf, int *buf_len,
                                void **authorizer, int *authorizer_len);
        int (*handle_auth_reply_more)(struct ceph_connection *con,
                                      void *reply, int reply_len,
                                      void *buf, int *buf_len,
                                      void **authorizer, int *authorizer_le=
n);
        int (*handle_auth_done)(struct ceph_connection *con,
                                u64 global_id, void *reply, int reply_len,
                                u8 *session_key, int *session_key_len,
                                u8 *con_secret, int *con_secret_len);
        int (*handle_auth_bad_method)(struct ceph_connection *con,
                                      int used_proto, int result,
                                      const int *allowed_protos, int proto_=
cnt,
                                      const int *allowed_modes, int mode_cn=
t);
};

Thanks,

                Ilya

