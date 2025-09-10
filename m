Return-Path: <ceph-devel+bounces-3570-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F18EBB52138
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Sep 2025 21:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10C0F1C87E65
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Sep 2025 19:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799022D8780;
	Wed, 10 Sep 2025 19:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HX1sdZ34"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF6C2D6E51
	for <ceph-devel@vger.kernel.org>; Wed, 10 Sep 2025 19:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757533061; cv=none; b=DfCIW4sryg3NttTcD1lir9BkiBat08vlMmSEOKGLXRd1Pub6YeUnbwciblRG+V73+Ql8kBkjmQcYjPBH6RjxBvlrCu0YlCWAjB48KMTzIXRD1Qg9iyiYZ45HjbZIE5g80PSptm7Xqz06ji2uJBjv+U5ZxINCBPKBXk9YD9100E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757533061; c=relaxed/simple;
	bh=SEcgaTUXEwxf7f+1BF/e4nhajrsomx+pHJxBSYVfNcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jY01HPYP5VC4j8aXgluvKz7ZG1fgeCrBJW62s7ylFPWFg7BcCQnf0tJBW+CBUxZwE+7t5LmkjBoR7QHc+BP6dAZ8Zunq1W+zGmXC8fF6JTQPHEsdZ4BWopBdFKIEg4h/Cow2f8wopt92QUpZyoN3tRuLqUp+L5uo4vUNRaTB7Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HX1sdZ34; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2445805aa2eso71581435ad.1
        for <ceph-devel@vger.kernel.org>; Wed, 10 Sep 2025 12:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757533059; x=1758137859; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOEIl6lmmrAktFSSIsuWXp2DXdXv0845ce06eK3955M=;
        b=HX1sdZ34iG61WJpRr4GOjpLKyaxQ+3zCrPEHjbhXKFxFS3QzKlrvODZKY2iuRJTnQz
         3TTa3jxgJhO3WL1ORp9M5VfxCsPkhLQr8fCbjbzX2UW4BbyzieXBnCbrXYrgzqmNjUdQ
         vAV/nKwRESGemGdEz0yd+X6Lq+I5LQd8vHY7ayeNXYwoFadAQGE/dnv2BveupLI5RM7G
         uJnwHQTrrLi3vWIiSLAhmI7GYZN7/5dnCgjxndnm79j7XSHl0wyJnDQfW6rurrshwJB3
         YO1EDH1jGtn+AAw9s/5TKmuQqzbmZgcRVeskDELZX9tJVzV05oe8aRmis9Le8sTaRiLy
         YN1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757533059; x=1758137859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOEIl6lmmrAktFSSIsuWXp2DXdXv0845ce06eK3955M=;
        b=NCRAq+jQxxlWutoqt9AuX9WdD2qwkUj74eZu3iUvUkPg8FAwhMr2zrokBNuLWb+TC2
         HPJSstTY1nGg0hSf4yRBguUnfUQXE41gsufCJ26XMa2cU3lGcxAoERTgl+0cgogA88M/
         v35eCxk/7/6/ypQgSv+HfDhbAJW5egmomdW2bZXDOSbfeCmt0VJPXtZfbpy26V8Ob3Z8
         t3OTfzUGWeGEojwujQITbEaggtruFGh4LZSsh2/rHUq15DHn4Qhc2/LoecIHcK/9h/e4
         fnf+aTM/4alddsgh3B5L2icTustdkkpMbuO2+8VU59ZlrW7srJkdv55jE/oQugrqC/zP
         g86A==
X-Gm-Message-State: AOJu0Yzd8K+43pdyLSk5HMcmGabz7AiYnBbj2eVQHnRUVZKlOvGztbUS
	NGA8RPFNUFA5SVJcTcudcvvq1O5D255yaBrwhEQ4WwPLVjaoOPX9LPedPyD9YdPGX04Oi/FM/YU
	1YbZ7Af6mXyIrdrbFOwkxo6yvpdchVBw=
X-Gm-Gg: ASbGncuHmrdTdRxQFXzygXQ8q4MukSJi7BQSggvsC0FVF1Qjpfp9PIMM59bmufqT6B3
	2KV7KvOZOKSkke+MXlKU8mCZnoUNNNG9qGWQpbh+7nkzML1pE3lSpm2Hr/uyHJ3GgWKATNffQwU
	aYhRp0WCudiQveHL55ZPR4A01jowjw5xLmWoEFflabs1taY8kmWjxal83hIA/L8hv+4hVnAzTnj
	aLfJhg=
X-Google-Smtp-Source: AGHT+IGRfgi93vlFFJ6x0noTqOArGHG0drN2u/5biAefuR9XmFZYQEr2szNK/HNP0tox7yra9Wcn2xAGeE0gq+DCOl0=
X-Received: by 2002:a17:903:1c3:b0:24c:a269:b6d5 with SMTP id
 d9443c01a7336-251681c493emr204306585ad.0.1757533058920; Wed, 10 Sep 2025
 12:37:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910105041.4161529-1-idryomov@gmail.com> <c83ba8bc5ed98c3609f43a97fa6ccb7eefe5b9b7.camel@ibm.com>
In-Reply-To: <c83ba8bc5ed98c3609f43a97fa6ccb7eefe5b9b7.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 10 Sep 2025 21:37:27 +0200
X-Gm-Features: Ac12FXzWYQtCA6nuiC1xw_t7wgNs8_hAVvRFDassreYoEwTrnUtbtFZnm7X_2CQ
Message-ID: <CAOi1vP9AefLoZ7zV=k=CDsVmqks9kWxBN5cn5c8gm-0y9SBtkw@mail.gmail.com>
Subject: Re: [PATCH] libceph: fix invalid accesses to ceph_connection_v1_info
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Xiubo Li <xiubli@redhat.com>, 
	Alex Markuze <amarkuze@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 8:16=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Wed, 2025-09-10 at 12:50 +0200, Ilya Dryomov wrote:
> > There is a place where generic code in messenger.c is reading and
> > another place where it is writing to con->v1 union member without
> > checking that the union member is active (i.e. msgr1 is in use).
> >
> > On 64-bit systems, con->v1.auth_retry overlaps with con->v2.out_iter,
> > so such a read is almost guaranteed to return a bogus value instead of
> > 0 when msgr2 is in use.  This ends up being fairly benign because the
> > side effect is just the invalidation of the authorizer and successive
> > fetching of new tickets.
> >
> > con->v1.connect_seq overlaps with con->v2.conn_bufs and the fact that
> > it's being written to can cause more serious consequences, but luckily
> > it's not something that happens often.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc an=
d secure modes)")
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  net/ceph/messenger.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> > index d1b5705dc0c6..9f6d860411cb 100644
> > --- a/net/ceph/messenger.c
> > +++ b/net/ceph/messenger.c
> > @@ -1524,7 +1524,7 @@ static void con_fault_finish(struct ceph_connecti=
on *con)
> >        * in case we faulted due to authentication, invalidate our
> >        * current tickets so that we can get new ones.
> >        */
> > -     if (con->v1.auth_retry) {
> > +     if (!ceph_msgr2(from_msgr(con->msgr)) && con->v1.auth_retry) {
>
> Frankly speaking, this check implementation looks pretty not obvious :).
>
> static inline bool ceph_msgr2(struct ceph_client *client)
> {
>         return client->options->con_modes[0] !=3D CEPH_CON_MODE_UNKNOWN;
> }
>
> It's strange that struct ceph_connection_v1_info and struct
> ceph_connection_v2_info don't start with version field. Because, it will =
be much
> cleaner if these structures simply start like this:
>
> struct ceph_connection_v1_info {
>     u8 version;
> <skipped>
> };
>
> struct ceph_connection_v2_info {
>     u8 version;
> <skipped>
> };
>
> But now it's too complicated to change this.
>
> >               dout("auth_retry %d, invalidating\n", con->v1.auth_retry)=
;
> >               if (con->ops->invalidate_authorizer)
> >                       con->ops->invalidate_authorizer(con);
> > @@ -1714,9 +1714,10 @@ static void clear_standby(struct ceph_connection=
 *con)
> >  {
> >       /* come back from STANDBY? */
> >       if (con->state =3D=3D CEPH_CON_S_STANDBY) {
> > -             dout("clear_standby %p and ++connect_seq\n", con);
>
> This comment "++connect_seq" makes sense to delete or to rework even with=
out the
> fix. :)
>
> > +             dout("clear_standby %p\n", con);
> >               con->state =3D CEPH_CON_S_PREOPEN;
> > -             con->v1.connect_seq++;
> > +             if (!ceph_msgr2(from_msgr(con->msgr)))
> > +                     con->v1.connect_seq++;
>
> By the way, we have connect_seq field in struct ceph_connection_v1_info a=
nd in
> struct ceph_connection_v2_info. Why do we increment this field only for v=
ersion
> 1? Version 2 doesn't need this increment?

Hi Slava,

Yes, v2 doesn't need it.  This increment is specific to v1, but there
wasn't a not-too-verbose way to move it into the protocol-specific file
and so it remained in the generic messenger.c as one of a couple of
abstraction leaks from v1-only era.

Thanks,

                Ilya

