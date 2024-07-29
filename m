Return-Path: <ceph-devel+bounces-1575-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E57B93F0CF
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 11:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB88A1C218C9
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 09:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57CC913DDAA;
	Mon, 29 Jul 2024 09:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="C4r9PlUd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AD913CFB8
	for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 09:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722244737; cv=none; b=YhU/AvnqF7CC4ZJcOKTmM4NtKgP8JXdLyNT3wYW9alknl79QhUOWYr5Z+fs2NVUAPN4auI4u6yqTFs3VDXpk0uy7TjG0YmwVbchVEX27eDg3UEDpDKtmQtq49+rCkMx+JbYnurw1/GnZ3yjU2SRJ+KM2a3dlygGsWOywdY+5ZHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722244737; c=relaxed/simple;
	bh=zP4Oo8VlfPL1y5ooMCv+q6dYa7B/A/lNVPXp7kK15YA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AdIHxeINH5Wc7h2u6gH0LLVlneFgT3QR9VFfqPE9zCo8Qv5OwUWlqO8JIjJAIi9Ssoge2x+AsH/T9sKjfrU8E4cfemMz+pPkhAb4L+THVsDRKNFZwFCwYhVvJG8jqdUd3n/wslDKmUu5HJL1+7y4ZaSAAEy3Kytpv6sa1cHTBqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=C4r9PlUd; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7a9e25008aso421124066b.0
        for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 02:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722244733; x=1722849533; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zP4Oo8VlfPL1y5ooMCv+q6dYa7B/A/lNVPXp7kK15YA=;
        b=C4r9PlUdhu4HMa0IKtW2rDSbWHDBx46lhHY/8KfX0wAC57bCOYPgP8GLjW83lw/WdP
         J+v6Jv2HI1dW25OeYaksCtJifWAEe/HilzQFARYLQVE648lhtJ7xaaGnujNG5f8By6uS
         ul4uOwJoqWbRskUwY8DW1JElMfaHXT4TxHDaBL0qDbPpw00u4A/iVLv6uTLPvkzzWZLS
         t8kDuFAkVo+tR0iG9nZlrn9PJ6oZuZx8G+PJRSQoTaj+StGe2mLD4GA55aVf3cKJ9+Hh
         mEHgrveuUzKId92nnAM8Y4sYPKTXA7Ol6pT2taxhY10vdlIX1kxGZEECkY1C8MWEIJ6l
         XKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722244733; x=1722849533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zP4Oo8VlfPL1y5ooMCv+q6dYa7B/A/lNVPXp7kK15YA=;
        b=fNZgCoR+B7p3ioVxhGSVh/tkU4gqpW2o050cxKlv9roCcEJwigL2jVQLN/DkbxWoUT
         nm0B/XJFdHQD5XhI228e6i/mLsoxfCDTbG7Y51Z1iBHdtu8A+peAGlgftSiEp/bJJiZH
         ZdjLTKmjejeyN3dh12qqWabLsWQtRvPSb0foLaPjLoD2SYRBupGf5UPeQ06/Ytp+hOm+
         LB5wGqu4qwcbWpswm8Vla8i+Gq02tXFV71JB1IjfnKhpPIN4f7eEIlYvoXd+6KNN8IA+
         VbQYRFAc3ng+pfk2QSRlyCoGGcINtpf+arcWOAoyU92pI0wUTnc851xnovZct65hJSwp
         M/jA==
X-Forwarded-Encrypted: i=1; AJvYcCWq0oa71fEl5sR4oNxyt5mMemPjPSkMDg3IrLBdCB5pwm7+o4n3vXtgvS0pUKE6kzoptWdvJZ3esNsNZxXMA2T0Xqk/vJlJoKLZAg==
X-Gm-Message-State: AOJu0Ywm3XU+rJFyt2yijD3DfyP/gRt9WiVAUgLsABHFbZ3KAxvEw0V1
	GJiW+wXNKMvKDqjkY4nIS2PqepGXVesCAoOHV3VyQFkMc7bM5Oy88wtMrRVy8zLb0dSAvp/RY+8
	vM66Bko1pLauQf24QhRuTF0J74XsnsftGE9OZjQ==
X-Google-Smtp-Source: AGHT+IEMMA8egk2Qrs/8YwOO8v1/PGB/RaFQ9lcTBCtxwZZFTvrycQmzBYT2gE5tB6GWwAAQvzXd5f7JMOHEksDWTYk=
X-Received: by 2002:a17:907:3e1a:b0:a77:b5c2:399 with SMTP id
 a640c23a62f3a-a7d400af792mr514406966b.31.1722244733283; Mon, 29 Jul 2024
 02:18:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+_DA8XiMAA2ApMj7Pyshve_YWknw8Hdt1=zCy9Y87R1qw@mail.gmail.com>
In-Reply-To: <CAKPOu+_DA8XiMAA2ApMj7Pyshve_YWknw8Hdt1=zCy9Y87R1qw@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 29 Jul 2024 11:18:42 +0200
Message-ID: <CAKPOu+8s3f8WdhyEPqfXMBrbE+j4OqzGXCUv=rTTmWzbWvr-Tg@mail.gmail.com>
Subject: Re: RCU stalls and GPFs in ceph/netfs
To: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, netfs@lists.linux.dev, linux-kernel@vger.kernel.org, 
	ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 28, 2024 at 12:49=E2=80=AFPM Max Kellermann
<max.kellermann@ionos.com> wrote:
> in the last few days, I have been chasing a 6.10 regression. After
> updating one of our servers from 6.9.10 to 6.10.1, I found various
> problems that may or may not be caused by the same code change
> (abbreviated):

Today, I gave this another try and it turned out to be a simple
leftover folio_end_private_2() call. It was really caused by commit
ae678317b95e ("netfs: Remove deprecated use of PG_private_2 as a
second writeback flag"), after all.

I posted two candidate patches which both fix this bug;

Minimal fix: https://lore.kernel.org/lkml/20240729090639.852732-1-max.kelle=
rmann@ionos.com/
Fix which removes a bunch of obsolete code:
https://lore.kernel.org/lkml/20240729091532.855688-1-max.kellermann@ionos.c=
om/

You decide which one you prefer.

Max

