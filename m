Return-Path: <ceph-devel+bounces-3582-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2734EB53833
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 17:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C3391BC3060
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 15:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA647135A53;
	Thu, 11 Sep 2025 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GU8Gyb7P"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7DA341662
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757605826; cv=none; b=bA83zmKY/v0koU0HW3utZdBk4Wl+0PulaeijCZdAfIn9bEBPfwIyspe/AVD8hdVCfX4bMc8xJPOHNbSwAax7ofGN3be9Exwmiedd1gFfp9p0vfr1utfncbFRJ1j7ThrFY0TevbvM+zzSM1x6VC03vooI+ZzbXmCUJGNNY6ZWONk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757605826; c=relaxed/simple;
	bh=AVPIcj7/hHgkX+g4Z1sIxJH3Jfu6UUxYUve4DBl59+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GncnWmmOEVZR1tnzOK7xXlPU7VJuXxL6YbSJJC32EmCm6xupRJaRVEjHGgFb74VjHsg7+MqPuPCSayJcylyw1ionrZeiEHLVhNoroASVaHKkNrUfBi3pUNXot91+wJfXT+E8K7rMaa6IjC/i+fuSnYlUmuOPbf1JNmNsut9Kibg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GU8Gyb7P; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24cda620e37so1461955ad.3
        for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 08:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757605824; x=1758210624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sm39d5NFqL/jKxwzJUkYjs0RqtR2b1iX+TUT2ANp2Xo=;
        b=GU8Gyb7PrDLaehgpAqUSqvzvBo3t9iwxc4ecGstuKBv4mVEZsVIjsKCrZfSwad2YTU
         Mxwj973APa2QgIRKpc+4ucpFRksE48KBLleM/LA7u5xNM0l4AMuAcYxZ+usJnkDc/LrK
         ov9nEyJZSRLdsod4X+3HivOWkyf1P3BPfEYU+2/ia4HK+OGxCjp2O45fE7nM8c2BVEM/
         T+Pxmf8Nszw27pE7pNBzH++k1/H9PkRx8gC6sOqizJJYsL2zp/q5C5sXy58iiU/A1fGK
         XOxTJcSVTZISTaZiGVh0JuOjkVJmVA2vBxYQ6hRC1vY3tENCsnUcdqNSMHRxKORyIhug
         0fNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757605824; x=1758210624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sm39d5NFqL/jKxwzJUkYjs0RqtR2b1iX+TUT2ANp2Xo=;
        b=SB+y6H4qLhrPgbL5eTdxroWK1X0BBaNqKrF+scR6+LrwHsYW94vCRQ2LF70qprnidd
         HADQ+J5Oy1CA+SjxgEFLn0RyLgyBWknIr92PfjY31O+pFPrk+UZEwOY+6t4ax5eLAY1h
         /orMab0jp4tF/9FQVcw8NxyVYzScTVBugKjjhpVxiSbRwHzKGLUjiM20gNpRDhx+aSl/
         hg9Zx4dcKmBX0VsiW2LK5VP4DdTE3mF7Hx2V9cHVvDGEc5fvRgSVzy0APg3oJ1WaBMaF
         myLknxgkbn7xy9IHcCnwSWKK/ApofU8VQtmGteiOp6eb8Y3JpJ41MJ+jegeEQqohMW+Z
         C07w==
X-Forwarded-Encrypted: i=1; AJvYcCW3rl3Zx+eJ6diJfORNQ9IzeFt/cHa3gevJUaw8dLiSL3ddrP3M+rvV4WQnb7d1ol0ZfnPluHqO2yPr@vger.kernel.org
X-Gm-Message-State: AOJu0YzoSx5Xz8M1jw+FRmLmHSNrWYqMMtwrPaw2g7konaARriezKPLe
	3HxWKkn/85mGnJewZmgz9aRK/AA/7JcOqB2VpYUk2SEKc4nP1Lz/J8JIf9cys08rx++opRRSYNx
	vK0BvsxGHFZcJE+CoJkQ8RX4L39KQ94jatruLwWwM7Q==
X-Gm-Gg: ASbGncvIoqD3aKcpzHSKlxA9SqW8xjFl/k9rvr78EI/6qW+Bi50DfC6dWaCSVGB+N8P
	GME+RYCJijbKesZmDgnDWOPHclcxWdZ8tbLIUecTG7jcPmutHK+KYVFG2F1u9RV2DDzScTJljYA
	+H8xoNUsmro5FKMdfAJk3+3aNmPIQKnZJMExNl9ho3Ao/Tuz8zHGKWdsdf2q0VCZZ65fkuOohaf
	cepBGW3cMAvGg634T2OjnJX1GPCZ+XkTl28JOY=
X-Google-Smtp-Source: AGHT+IHeD3ijdPFv6sWC+2qqn5ewuQ4r5M61SalEw+nEx55NKT7Qlty/iU0ChnsPVabDot6LaASoCZDlZs00KT1RgN0=
X-Received: by 2002:a17:902:ec8e:b0:24d:15b7:1fa4 with SMTP id
 d9443c01a7336-2517653b663mr140062445ad.10.1757605824176; Thu, 11 Sep 2025
 08:50:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw> <20250911073204.574742-1-409411716@gms.tku.edu.tw>
In-Reply-To: <20250911073204.574742-1-409411716@gms.tku.edu.tw>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Sep 2025 08:50:12 -0700
X-Gm-Features: Ac12FXwoL045SNoj1J2Tk9bFEh24Fjp_N53zMjtCDhxT-Fzyr-6A0W4BpkqjnRk
Message-ID: <CADUfDZqe2x+xaqs6M_BZm3nR=Ahu-quKbFNmKCv2QFb39qAYXg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better performance
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org, 
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com, 
	jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 12:33=E2=80=AFAM Guan-Chun Wu <409411716@gms.tku.ed=
u.tw> wrote:
>
> From: Kuan-Wei Chiu <visitorckw@gmail.com>
>
> The base64 decoder previously relied on strchr() to locate each
> character in the base64 table. In the worst case, this requires
> scanning all 64 entries, and even with bitwise tricks or word-sized
> comparisons, still needs up to 8 checks.
>
> Introduce a small helper function that maps input characters directly
> to their position in the base64 table. This reduces the maximum number
> of comparisons to 5, improving decoding efficiency while keeping the
> logic straightforward.
>
> Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> over 1000 runs, tested with KUnit):
>
> Decode:
>  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
>  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> ---
>  lib/base64.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/lib/base64.c b/lib/base64.c
> index b736a7a43..9416bded2 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -18,6 +18,21 @@
>  static const char base64_table[65] =3D
>         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=
";

Does base64_table still need to be NUL-terminated?

>
> +static inline const char *find_chr(const char *base64_table, char ch)

Don't see a need to pass in base64_table, the function could just
access the global variable directly.

> +{
> +       if ('A' <=3D ch && ch <=3D 'Z')
> +               return base64_table + ch - 'A';
> +       if ('a' <=3D ch && ch <=3D 'z')
> +               return base64_table + 26 + ch - 'a';
> +       if ('0' <=3D ch && ch <=3D '9')
> +               return base64_table + 26 * 2 + ch - '0';
> +       if (ch =3D=3D base64_table[26 * 2 + 10])
> +               return base64_table + 26 * 2 + 10;
> +       if (ch =3D=3D base64_table[26 * 2 + 10 + 1])
> +               return base64_table + 26 * 2 + 10 + 1;
> +       return NULL;

This is still pretty branchy. One way to avoid the branches would be
to define a reverse lookup table mapping base64 chars to their values
(or a sentinel value for invalid chars). Have you benchmarked that
approach?

Best,
Caleb

> +}
> +
>  /**
>   * base64_encode() - base64-encode some binary data
>   * @src: the binary data to encode
> @@ -78,7 +93,7 @@ int base64_decode(const char *src, int srclen, u8 *dst)
>         u8 *bp =3D dst;
>
>         for (i =3D 0; i < srclen; i++) {
> -               const char *p =3D strchr(base64_table, src[i]);
> +               const char *p =3D find_chr(base64_table, src[i]);
>
>                 if (src[i] =3D=3D '=3D') {
>                         ac =3D (ac << 6);
> --
> 2.34.1
>
>

