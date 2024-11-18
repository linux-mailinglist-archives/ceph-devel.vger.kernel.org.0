Return-Path: <ceph-devel+bounces-2161-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 902509D12CD
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 15:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 564D5283AF7
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 14:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700A919AD7E;
	Mon, 18 Nov 2024 14:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LqRIXxQj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03F87483;
	Mon, 18 Nov 2024 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731939579; cv=none; b=R9QuoOAG+u2focXZ+ue+xvLdnHwaOKtiCd4GFAXqsn4kyjFvSfEN/qDTS8RcXpfHtaBi7S8fVmQD/41viEY+ZfuqGEELrLFWO5qvqnCjqkhm/xphgN/Zf8ElVN6YszjZ6JFXcUeQ1djc1OFch+UIpM+fF30Bdv8AktXlGEUyJgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731939579; c=relaxed/simple;
	bh=XPHcpLf9uKAMD+mMygPbEkcoqh6WZfFxNnK6hpXbhzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XnA4S1xtksfaZDHo+afpXzRU5IwkaSmx4MyysrteTrMd+//xNKYtf5ir3PRkfJbATJy1CYWBV1iZI1MagCYbOWObbIIzKcn/fRXfcnwFm0nFbiTkVw8FNSvXazo5uqQytyJWpd9dTgeKawiXQB0Nh89ekUfWiakAMibG5VjdoK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LqRIXxQj; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7f71f2b1370so3040771a12.1;
        Mon, 18 Nov 2024 06:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731939577; x=1732544377; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U00EGzWGeKcaXIfV/6kPk/TG9r9I8YziXisamN2M3o0=;
        b=LqRIXxQjs3PkByhXyVKEwc8NyUsCRax+HHA/viCHzgLIsolzZoPiN5VeAejfthN8l7
         Sc+de+lH5JZi9b2B8GY8j5SAwI4Po4ABRnDxxHGigGUNsJeAFHOwrsDh9nkMvWt9sw8H
         Jljl6B088W/JCGbzM8rVBz4d8pW93iEPiEX8arOjMXHO2JRlp/8So85IqDcTfXtC8LVG
         h/Vqp7zhJs/AS7A31Gx7EkC52BU5PHVPQXHm2LEq3luLu1TaTt6CSKqckMLoMqjj+16w
         9ALx21KBO/LZpzYCniIvNpt5i8Dh0fhJ8wGw4C9RNlvop4Q/2ZUPa/e2DGkS2jZPWgru
         2BhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731939577; x=1732544377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U00EGzWGeKcaXIfV/6kPk/TG9r9I8YziXisamN2M3o0=;
        b=gbIv6wbnFMFKPxd9kH+1lUCFhRZkx9fd6RflnDqYsVMJHDZBPNNGKMiUQoesddXssf
         Kwl39k9MMx6/APE1cpfJIILBqPISYzR7EYA8SbDWh/rTnlghitf8Ikx27MCM1bDr8PCz
         vzsuB2GPn3VjnbpQuGf1xIMloth0XS1Uhb1szeJNVgG02feUgyE3gu5aoUqmk5JG07jf
         Ak0m9J4YQdvMchHO+l+mFYoBKza2z4WHoINjNLjdxVlhKhnevQTwBn7JhFGz4EzOTBxB
         YVsBOuCFK4zJNBcJxxjEzYksaCvjdi1I/vww+G0d6ByvPjtPzD0DWoHUKZ2gBXAM/UDm
         SDow==
X-Forwarded-Encrypted: i=1; AJvYcCVZ5XMS43pBsuN1nGIzKvXG6Q0PVZpHtlTwNvDbdBN9LV5a+tltervBRmeJlZX2MseGVBV78NE0Y5YQ@vger.kernel.org, AJvYcCXIgNw5+EUARpxTpuhfLWcL/W+CEcdPGfr59wDMAt4mCL36s4mvARJPyzR/eF0o9TR3/SoelYgHSOWnAvnA@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb+XNtRYhiYtFfgVcgMJwYJ4oRgbOhwfN2rsxBqZuGGVgrhUX9
	8hbbqiJNkikkW43D4+kpoohFGCgfN7tJfFcQB8i0GZn/+AkHaLmZt+557vRe01k+nwWAFUFMkUi
	EeY4xLAHOCepXoVj9NPts/w8+OPA=
X-Google-Smtp-Source: AGHT+IEeqiDy8gFBtHcm3wt0qNlJkIkgLHtbxpUFE3jBVTNcJp00ThXM9IxTRRtpEq4hpOk/Fk+T3FuqnORdV6WqPvY=
X-Received: by 2002:a05:6300:6306:b0:1d9:2694:44f0 with SMTP id
 adf61e73a8af0-1dc90be736emr13006509637.35.1731939577038; Mon, 18 Nov 2024
 06:19:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112211439.207184-2-thorsten.blum@linux.dev>
In-Reply-To: <20241112211439.207184-2-thorsten.blum@linux.dev>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 18 Nov 2024 15:19:25 +0100
Message-ID: <CAOi1vP_3JmofvsFiCiF0xvz7aS4Z5o9MEW6=bWEwuxtAc_sPmw@mail.gmail.com>
Subject: Re: [PATCH] ceph: Use str_true_false() helper in status_show()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 10:16=E2=80=AFPM Thorsten Blum <thorsten.blum@linux=
.dev> wrote:
>
> Remove hard-coded strings by using the str_true_false() helper function.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  fs/ceph/debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 24c08078f5aa..fdf9dc15eafa 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -357,7 +357,7 @@ static int status_show(struct seq_file *s, void *p)
>
>         seq_printf(s, "instance: %s.%lld %s/%u\n", ENTITY_NAME(inst->name=
),
>                    ceph_pr_addr(client_addr), le32_to_cpu(client_addr->no=
nce));
> -       seq_printf(s, "blocklisted: %s\n", fsc->blocklisted ? "true" : "f=
alse");
> +       seq_printf(s, "blocklisted: %s\n", str_true_false(fsc->blockliste=
d));
>
>         return 0;
>  }
> --
> 2.47.0
>

Applied.

Thanks,

                Ilya

