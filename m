Return-Path: <ceph-devel+bounces-4022-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B117EC4FE21
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Nov 2025 22:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5C1CF3493C5
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Nov 2025 21:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73AFC32694C;
	Tue, 11 Nov 2025 21:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6UltxeT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6276326938
	for <ceph-devel@vger.kernel.org>; Tue, 11 Nov 2025 21:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762897037; cv=none; b=shLDUhadymu3tWB/eYpNWGXUl7m63tUKHWL689KrZa6c5Ymp9ZFjyHOGsvaJBeKvxUwh3WQ6NMh04EtBlG0J0kb29XW9ipRFNKQw3/7YRxSHXqnsSuaZUFqqJL8InbidpYLMH7wLtJEKW4y8ymZKhPBw9ZLJVZ31zV6ZRpHEZyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762897037; c=relaxed/simple;
	bh=EYDbDcuROBgBT+pTg8UkpNsR/0U0TMWxx9V21LB4ea8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mha3DTRrDzHh5/ycC4PfX88UFDZjeFoU1apyZgbcmFISj8I3d1UbUs0re2BB085NPXca5wIYiuzohy49ZDcmEUT6MxwbVqtxnev+G+SF3ardz9z3dhV6kKVOfPXaLbgz1PiSHkOGVpBqm9YKOl0Pg4mmTeo1ei9Hx/A39Q7zQ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6UltxeT; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b98983bae8eso97269a12.0
        for <ceph-devel@vger.kernel.org>; Tue, 11 Nov 2025 13:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762897035; x=1763501835; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTkH8R1tmJJjrkk9nlGD9gsFksiAaPNa0XLwG/EYRKs=;
        b=C6UltxeT4LBmpMVPEiRszq+luP9uQBsNXKIxxNObGcig4iHH92PuqtrOvCbvtJIwdU
         4yR+AUjxa3tqg9ZqA46WkX5oAAAU1Dz35HY75FwpgFFtZjXBsqO9z51wpRGvNm8zT3YA
         VPmWDru0+a0ElH1JoRT8MR0taFKeSOpJ+bMqu+eyVt2V2R7eOjImDcS8TOi1lqjIhoAl
         yQBoAgVhs8vYJ3bUoWLqa0lZpXXhqnOVPtPzPzEMNa4e6uhXWl/JFauIcCTUkF6SSczQ
         ETAOEtvdM+sfmFGPg2Qr65BUtRIfax78pcirx7+VHR8YRAy6tUhE+0giCEzqOwIb1pAx
         2m7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762897035; x=1763501835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RTkH8R1tmJJjrkk9nlGD9gsFksiAaPNa0XLwG/EYRKs=;
        b=Gx3M7r8JJA8VnQ4XaSJlNR7TZEqu3YRXvtRjsgsHe5/MSEoFLJP5c1t7rS17PqPesM
         l721Q/OUCjKYowcE42WWTnzJt70Os0Y+YqawjBLgaHfFk3JQSV2+l2qOZMnIKFLHJuNy
         vEld50uppkXOu5zjHckeuVqjtn017G/M/6+Ubs5TCbyabOFXoBjR2iMeKpnONZfac/PF
         W2C4IVYhT2ybbPTH3AaoyMId8566WgoVU23GN5GjAIau0qqYBNAetWlL2ULNzSoHFWjk
         Y5wB/VlHAM19UKDPljuljneadEjYdYjaHgNDlNMs4Rxd741J0tO4AajIz+ohe5WSCvE1
         Yo8w==
X-Gm-Message-State: AOJu0Yzpe5D41MuBzXDw5GSJXgG7H9oB4hyvaH9knYeckWgfM1EFrSqs
	F9pWn2s8RES+NkLbTUxjMZ/ygrdg9SJjb3Bq4dD2IAFz5rdQvh4B/FprJMTUaQk8CCRyNlajUuq
	OpZhuJq7pmG3DIH3hX08n4K206QWwrXs=
X-Gm-Gg: ASbGncvjh81WZcl2aFwSdy4ZiscYIMnX8hOktDuyKZOBt+YdUQsesRpvYr7iwgCBEd6
	qtzc4xgOEVrverhwMKoYYS3y2eKENdjwkq5XBZODP9sPEx2xpPN3SSSI6AOrpGQmFLkJWDZnZ2s
	TgVKlKs50z43wY6+JNgvqdqL4fgaEqK5RSpAscfonyk+2FDbMyuf51+gwCjMCH+xzrXdmVuaRaW
	KWlAKjZZHmtnZncVuqZ55VTl+egpBJdA2eFkb//IDBNMD+jgyy1IfJHr1AwiGRUCcn/YyE=
X-Google-Smtp-Source: AGHT+IGouFBEbImDSLi3o8hAs4vG/yROxxQ5Ye+ck7MBfPE/TMSUahljkZ0pr4e0Jtg+dx820cxj2OcmRrdUMuaXaNw=
X-Received: by 2002:a17:902:ce83:b0:295:9e4e:4092 with SMTP id
 d9443c01a7336-2984ee05655mr9153845ad.56.1762897035186; Tue, 11 Nov 2025
 13:37:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251111205627.475128-2-slava@dubeyko.com> <CAOi1vP_tHEgBn-+EmSeOtpWnQezEZDnGWapGZ3ngXZYkzvPpiw@mail.gmail.com>
In-Reply-To: <CAOi1vP_tHEgBn-+EmSeOtpWnQezEZDnGWapGZ3ngXZYkzvPpiw@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 11 Nov 2025 22:37:03 +0100
X-Gm-Features: AWmQ_bmeptX2xT3ZqAGwLnw2pDIbz79m30BfjBNgOZ44D9hCNFZfrND2Dbww-3o
Message-ID: <CAOi1vP8uaeSQtnHKSk+=4121VDzNB2tDD+rPZkMzRb4GzD+3BQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix crash in process_v2_sparse_read() for
 fscrypt-encrypted directories
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	pdonnell@redhat.com, amarkuze@redhat.com, Slava.Dubeyko@ibm.com, 
	vdubeyko@redhat.com, Pavan.Rallabhandi@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 10:35=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> =
wrote:
> >         int ret;
> >
> > +       ceph_msg_data_cursor_init(cursor, con->in_msg, con->in_msg->dat=
a_length);
>
> This line is too wrong, please wrap before the last argument.
                   ^^^^^

I meant long, of course.

Thanks,

                Ilya

