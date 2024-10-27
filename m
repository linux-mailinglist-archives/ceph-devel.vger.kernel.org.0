Return-Path: <ceph-devel+bounces-1986-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF539B2077
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 21:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79014281D1E
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 20:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD24917E472;
	Sun, 27 Oct 2024 20:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0LooTd2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19A5558BB;
	Sun, 27 Oct 2024 20:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730061668; cv=none; b=awx3UaWhDIijCNhqV62eU2bw/LI9NqFKEg8tQcSXo+9pVXcGFh6q+iv3lJa4UJePVx1GN45QilQTQt/QCSvAQavxNNvD3b0BtuTtmQL/wpnRo09AvaTkok+b6FXndA3syy9wX8u2US3DJvNWj8zfb10dEMXa4GJ5fcbuQsdNpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730061668; c=relaxed/simple;
	bh=j6zZJd27rgLbrZ5NTRtCJlGPSSgjUXBSM6i4ASNcR1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N8nT32acNWg6MoGIKMlcA7J/73eB4oYlFGvexAexGUqo2nn9/lU30On6WwyKdHnNbjpQR411AU8QXhbYe8v8iWidXGXcLfho6sgEPykPoxn32soVHdbM6l4vePunlB3Z+n7Tum176uc41dI4kezPR6uiXIbuF3Nlf1TqL0Q4bHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0LooTd2; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3e601b6a33aso2149239b6e.0;
        Sun, 27 Oct 2024 13:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730061666; x=1730666466; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVOMgAe3RRwdAR+xhS/ahUABlt9WYQ00kCmXKennVJo=;
        b=a0LooTd2er3ZY4S5SmB6GGN4+DfSCer4XDFnYKqwEq1tLFHArItCdUrPNxVT2gUbAw
         hk0Q8Fhugt90U9w4gwBkqDnbi2Zr6oxOs7a4en1F284y66Bqb+0IJseD+quAYL32SM3B
         bCjJo4jThAPYjrFqg3fcH8yG4nXYu0tHudzuHYlE9CrsaxgPA4f5ZC1Vp/+3VSp/lwnf
         1xQ/hHckJCgnCVRXhkvC/MLKAg5mW5U0bKUAzhKEjabrVwxYVCD+sSDS0gJoD0u+kF+y
         mE7Vr8401KzJSAO2rD0YmuGhxUm51MGrMZngdGUWNPgDVkSQX7ngzqt5e/yUGpvOEL//
         gDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730061666; x=1730666466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tVOMgAe3RRwdAR+xhS/ahUABlt9WYQ00kCmXKennVJo=;
        b=TFUM60YgGLGjZOuXb7ce6xsAZKHHHX4/NlCcozJImjP/0C75PdZ1fdKGA6coJ7F1uB
         X0LBuYA3Qd6N5JHnP1YWmx78jtQPTWNBYNl1n9QbFWsPZyMo5A5YI33MbHOGy6AMa0kr
         N6G5xMhMdW4XsYnsaqedIOtzcUKS/4FQBBcYk1CKJQZ5TmxfzRtvCDk6e3O1M3mNpPj6
         TEw26UsvPGyJEq1tVgr93XQq8C5R6mF+f39E6Cx38qZeYj0Ygrg4+FjSYOZHL8uOciSS
         SkLPmtTfMKtyt/p9rH6UgJG+OPqyyfhpffbXOzkHTufba3iK/Bao9hLDYpkp8ludT0gB
         Vymg==
X-Forwarded-Encrypted: i=1; AJvYcCV2uByCxh7qaNdcqSbXwd/jMEv7v0yop4ejgY1ZP0kuuPefuhy0WVcoMZhpGyIlHX6MpsRPZvuwO4eSuVlL@vger.kernel.org, AJvYcCV526IcZgZKXcId3zjmEg4UBQytYU8gDWB9irb7Mpe4daysHh0Q++Ig8Vcq4HBQNsY0kGsRm1rQ@vger.kernel.org, AJvYcCWzgicvB8eZcQVZ5Ax04UeCfdTVEgk/5d2bxtLt+Rkv94u46OK+x974vXQhyWi2j5O6zxx0ZDCeITjU@vger.kernel.org
X-Gm-Message-State: AOJu0YxlGhxjq1PoKt5WrqDXFv/zH67PWbfaEg36ghD7nn07NON4CwOJ
	S0NheYQ10nvafT6+Iqz3W4IJ28fdG1V4+6dqGAOY+WViOSIFR49BB61l6aMA+3+kZYUHG5/5AHM
	m1QxZgLg+vGYTkTwyfptLRSV0EGk=
X-Google-Smtp-Source: AGHT+IH+JxOFEQ+kqwejAXVzFqiU5acSuZcO22SFIm9cfV1KUI4DKv5HE7yFAFL/l0kl3yq2Zo6FvD7AK4hJebj41T0=
X-Received: by 2002:a05:6870:450b:b0:277:df58:1647 with SMTP id
 586e51a60fabf-29051da0aa4mr4481229fac.35.1730061666001; Sun, 27 Oct 2024
 13:41:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241011224736.236863-1-linux@treblig.org>
In-Reply-To: <20241011224736.236863-1-linux@treblig.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Sun, 27 Oct 2024 21:40:53 +0100
Message-ID: <CAOi1vP9au=SqKfmyD79YA3gCGOCj1FjLNJxtF9N_k0cafCJ3uw@mail.gmail.com>
Subject: Re: [PATCH] libceph: Remove crush deadcode
To: linux@treblig.org
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 12, 2024 at 12:47=E2=80=AFAM <linux@treblig.org> wrote:
>
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>
> crush_bucket_alg_name(), crush_get_bucket_item_weight(), crush_hash32(),
> and crush_hash32_5() were added by commit
> 5ecc0a0f8128 ("ceph: CRUSH mapping algorithm")
> in 2009 but never used.
>
> crush_hash_name() was added a little later by commit
> fb690390e305 ("ceph: make CRUSH hash function a bucket property")
> and also not used.
>
> Remove them.

Hi David,

The implementation of the CRUSH algorithm is shared with userspace and
these functions are used there (except for crush_hash32_5() perhaps).
They are all trivial code, so I'd prefer to keep them for convenience.

Thanks,

                Ilya

