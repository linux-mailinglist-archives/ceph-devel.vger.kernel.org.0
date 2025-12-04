Return-Path: <ceph-devel+bounces-4158-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED28FCA4698
	for <lists+ceph-devel@lfdr.de>; Thu, 04 Dec 2025 17:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ED0D9301738C
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Dec 2025 16:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DC72D9792;
	Thu,  4 Dec 2025 16:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QB7OtExC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E048B28682
	for <ceph-devel@vger.kernel.org>; Thu,  4 Dec 2025 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764864642; cv=none; b=paPrDrs++/AmvtlqD+2f9r9c9ZoPuu1si6zVcIUO56/08iRoJg8BknvftXOT+jEmN7fon4gw4okfK+JInZHlWJ8eKcpDPKp/NdMudg5hrun8ifJENfSosX9Q7+KKtmIylL5EyOGsvfMRYixJVCua9jMwbIWyTHIpyyBT3Jo6tjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764864642; c=relaxed/simple;
	bh=6t6FkGbGFanqbUcgTvRYXB+4zbo1ACzql3K80nW06N8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=durd17fPrt4h5RWYeQyP9gv+ZaoLSf2jCX0fw3Qge85nXJbViK80XnJyJIMj66Q+b4wn2kIRBxZzFKa/phNiGzlrpsvIZG7hbjWkXx62M6mm7+LJqmef96Oe0eCZW1Ka8uc2bGNNG/5SuBGAzuNQqON4pf6QnRV0TLZsK20h44Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QB7OtExC; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso1252120b3a.3
        for <ceph-devel@vger.kernel.org>; Thu, 04 Dec 2025 08:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764864640; x=1765469440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+CK2bDvL/AdMHcou2/8DWi8hZ1A0JAu2oY1p061TsY=;
        b=QB7OtExCt668V45AJu6wBexDvMPZGrMtmvbsYImVqthGzDW8CwUhXwwt6xuq4uP6Jx
         YM4X7NZk+zcg161nDSj3qx1/gyTfhgD83WLdC4xbtKoIPQnSB3MS6IzkCK47Oe1G0leK
         sGP7ZwLmMKO4WeKHgClPcDNa9mP4VtfB7WsCAds8twQSGXGMMyEbebw910ZycNbiHPG2
         54FWeNFqEm2EtjfmtMamW4M56SdWotR4WA96Dio4xDdXqpoSqbWQmwXGOcz9/zp4Kewc
         /IkQq64ERVYKo70g2UfeCfT+1P0SwC0PqkcHzzt29DUgkNQtW9gKLAp1o8Lnjb026Oui
         ljGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764864640; x=1765469440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l+CK2bDvL/AdMHcou2/8DWi8hZ1A0JAu2oY1p061TsY=;
        b=NM9WRvGnzugMr/Q0ZbGFzMvpyaQpmHKOK7xnwvx2ZqNgGQfsAwrGazU42xJtsxpiQ5
         2uJSqKjsYr6txcrZkl6D4//jqoB7Q70Ndt+dTRYWquoPXL6x6ifIYJ7dr+1CzYZjyWCr
         6YBO+baY6uFdOOixVGwjDXg31stOp1VMz2ZizJOrCPesKQcYww7CCSwSYjA1AbQpQbOV
         O2w+vlD/kZ2czjbShP3W2UUzJDd3YTRjAUSC+dDpm1bP3U8QcGfzeWM28oSXGUcmuiCg
         ZYYFN4NHHZBTJ/B1Z6Y6HzVkXk3ac7NNgnpxbbeqc4n8qIcOLL5xspCkQ24s+5M7HpPC
         /ngw==
X-Forwarded-Encrypted: i=1; AJvYcCUEyo2rtK0XGCFSqq69bCI1zqg+uHKIIhx1lknRrl8+XGoTv4AcScmY7NiAVJqKoHs8BPikiJNNwZxh@vger.kernel.org
X-Gm-Message-State: AOJu0YxzBdZsbijvUeiDReycwFHtbm0aIxxmJoK7t+19p5oP4KcON1Iu
	L7EBd63TkEbL16tEj7MXoVU95bEveNG6VKJiIKvyGh7rp6ctsfoDXNX6FB02FCIAsXu6nn9DGFL
	TvTGcV5SNQ6YLfNAnPEa1OBif+cF+cGQ=
X-Gm-Gg: ASbGncs3Wjl8FaARjGCzbRu4QIWMkhSnUa6Yuau28p54bTSsQAEp5n58/sblcKb6781
	5LE/rLrr4HdQvFQt5VrdNjff8SPruu/j94HUG5eg5ZC9wSJN4Bx7fYkGUe4o7Gb+fYikH80HRVP
	OqMIOSk/KxiLPMuwYCqap0LZoZNPq1G2rG/X+qZdB5ODA76iPb0FbHGB+uBq4ZM7qJF9QEOpSpo
	MtLNKmySsF1tCmniJC+xgJt7m2FxUHNnjYH3eEUn25anFa82TxFTDYWn44cude3lqtJW48=
X-Google-Smtp-Source: AGHT+IE9ItamSLUTs9rwusWtod4TvUnmJ7dTpadjS58kSXsEJqspTk9Xm5CJrTTw5VqIYRt9NRXIrj/Qlg0kT60ChRc=
X-Received: by 2002:a05:7023:b86:b0:119:e569:fbb5 with SMTP id
 a92af1059eb24-11df0c48b3cmr4871562c88.36.1764864640130; Thu, 04 Dec 2025
 08:10:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204061118.498220-1-ebiggers@kernel.org>
In-Reply-To: <20251204061118.498220-1-ebiggers@kernel.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 4 Dec 2025 17:10:28 +0100
X-Gm-Features: AWmQ_bkO_VN3zJYbIPnPJl8VBUEeFwJG2pmhKAPNBVOIUEd0rHO6EPtuGIC3B64
Message-ID: <CAOi1vP8nTeNinKN-SfRKeHRaH7c-Zci4TnUbqcmmftWWpc25dw@mail.gmail.com>
Subject: Re: [PATCH] ceph: stop selecting CRYPTO and CRYPTO_AES
To: Eric Biggers <ebiggers@kernel.org>
Cc: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 7:13=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> None of the CEPH_FS code directly requires CRYPTO or CRYPTO_AES.  These
> options do get selected indirectly anyway via CEPH_LIB, which does need
> them, but there is no need for CEPH_FS to select them too.

Hi Eric,

I think the same goes for CRC32.  Would you mind covering it in your
patch?

Thanks,

                Ilya

>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/ceph/Kconfig | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
> index 3e7def3d31c1..01a3e9a3a4fe 100644
> --- a/fs/ceph/Kconfig
> +++ b/fs/ceph/Kconfig
> @@ -2,12 +2,10 @@
>  config CEPH_FS
>         tristate "Ceph distributed file system"
>         depends on INET
>         select CEPH_LIB
>         select CRC32
> -       select CRYPTO_AES
> -       select CRYPTO
>         select NETFS_SUPPORT
>         select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
>         default n
>         help
>           Choose Y or M here to include support for mounting the
>
> base-commit: b2c27842ba853508b0da00187a7508eb3a96c8f7
> --
> 2.52.0
>

