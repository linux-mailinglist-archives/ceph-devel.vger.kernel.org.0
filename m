Return-Path: <ceph-devel+bounces-3811-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 461A1BC928D
	for <lists+ceph-devel@lfdr.de>; Thu, 09 Oct 2025 15:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D11E54EF17F
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Oct 2025 13:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A432E1F10;
	Thu,  9 Oct 2025 13:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bSrqB3rC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E4211713
	for <ceph-devel@vger.kernel.org>; Thu,  9 Oct 2025 13:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760014907; cv=none; b=Ipn9brC4NFlLRij7Xr4lqE81r+70DPs4aL9vNNvVbmbt3T/vu9FFKu5XBhZMf3AEIq2uYvVRzFqpHUFdYokB8AjK8fnRgbMv9seTMURaBE903Ysl+5k2LwwBoZ+61ffAFJGlgQH5Hr7SOx7r2tL0IJFmlgpew1XVC4S1jMcBjv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760014907; c=relaxed/simple;
	bh=Gs47qKyjjCbUeDk5wi2/Q6Ba91DMd60WfEY1F85BEAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ai71Az22211RLpFuRRByEgxoAOJD3p4GX7f748F+zs3DrD7kPh7GBsEmiu4ncu779vRqKy5rKhe8abTFLsbzQvWliTHxPcme716B9YJIflJn24hcrDIYCwdAg3pev8UCHxQQnz76en3hTmTc/hWbTdAZQeTyTgmHwJMiUl9ynyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bSrqB3rC; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso780309a12.3
        for <ceph-devel@vger.kernel.org>; Thu, 09 Oct 2025 06:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760014905; x=1760619705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcgGyufeWrwbNvU76gdgcnETjaPRCIETyHV991hM71k=;
        b=bSrqB3rCEnP8PsQUegBgfVVmHsiLaCuvDfV15AkZEaP/yCojaX6oE3kDqO1aoh2rVw
         kHcok5YYKxEqwIR8yJkLZlKfO/cKn0XMbB3YCx0bpY2SwZXgOd4vYhw3TSDGysjW8slz
         dl4rNGYXdL4qhF/hmZPMnXH+7i/xozM8MqemOwrtna3GY2gOjlqlobm4g/2rk9JtKXTv
         Z1wMckwYZx1mULsXIHlFR0WRaxxEnLAUz6N14vwLiQVPlvUilLWhQPEZgSgiqBOX+FbW
         7ge8N8iOQrZwo4+TdqTAI0jY7rpgWsfw5lx+kLBxbqtnzPzOwzW2ebwp2Zqtl/d/YdDQ
         ISSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760014905; x=1760619705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YcgGyufeWrwbNvU76gdgcnETjaPRCIETyHV991hM71k=;
        b=gjyG69njuzt4Bch20DTzl1MHxniUV6VKGZRbWF/KuYhwkgmZUlkDvJ6atQdG1w8iuA
         OIl5aK6Laj/vy89JSEaYE2fqbSwmiY6huPis8DmpWCijuxMfecvnYbR79l0PBJXNFO3B
         Z97jiHOXoalYHPqIOvEeRSmzGG4fENNqM9zyrqlgC/aayHRDJha7IBiWiR6R0eb4LOLF
         yRMgwN7R3BRwgF5MaSfRJVFS9pm2dBz2KORA4Aqph0LkIG4RYb/uMPWdbZuTImGEtQb0
         ZlhblhIJzGkk2eXP6wLSEzwqvkvhn1HClpLrcLX0oBYQh/8QE6gRUo6HCYh3ihZjHbe0
         ytgw==
X-Forwarded-Encrypted: i=1; AJvYcCUFBlnPBR4m2aaA1ejmOtt1IWdb/bhFcEOv9fMoc6JUm8OV3ipNWOa0J/hfX4DOd7YgJ5RdF3xyPwhK@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd5Ub1sZIWsZXQGc0pNl2gav4ZxM6EJODpTX7gjs5AwsgF5go0
	lf3Yvc6BK9AHhefeCkKtxsNKZ538k1grFDCiJNoR3WGRtzdK1CBwqjmFB/Do/2QBFJwmy+ZSYDn
	o4d49nwEeoTMQSDXXaCxAfUfK/S66E7E=
X-Gm-Gg: ASbGnct0k689JYbnuF/FlunCoan55Iv7FH48cw+196FnNjjE18bA3jdG+lARaHO0Udc
	tYoOKS07EygkHIiISTOTRAujYEdXEn1xFtah2fvvitoZPfFFiw/SxvjOOBwi5HhhwVE1y0q/MpR
	yP0E8rfSbZiUmjzejuuKgJO3n4ZhOu0WZVInQRpICYj5jsKfEH6cWgTrLPa/1mNo5R8fmp2nt48
	qPJl2jYFW/3RlNOLSMg17Bc2VBp4VMR9RGMR2ARkA==
X-Google-Smtp-Source: AGHT+IGYLUuOBqqW0GFGNDMWTwHGx99IL3xPXeKehrsNaPNEIwJoQjw5SqCX43PuDYbkab8vCV+1w3CcEjSwf8x0pa0=
X-Received: by 2002:a17:903:3848:b0:272:a900:c42e with SMTP id
 d9443c01a7336-290273ef069mr91199775ad.35.1760014905030; Thu, 09 Oct 2025
 06:01:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806094855.268799-1-max.kellermann@ionos.com>
 <20250806094855.268799-4-max.kellermann@ionos.com> <CAOi1vP_m5ovLLxpzyexq0vhVV8JPXAYcbzUqrQmn7jZkdhfmNA@mail.gmail.com>
 <CAKPOu+8a7yswmSQppossXDnLVzgg0Xd-cESMbJniCWnnMJYttQ@mail.gmail.com>
In-Reply-To: <CAKPOu+8a7yswmSQppossXDnLVzgg0Xd-cESMbJniCWnnMJYttQ@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 9 Oct 2025 15:01:31 +0200
X-Gm-Features: AS18NWDgVXdJzaBexOMeDAOr15F2R2gpSg5qJuQMSqlDa3Ke0Sh3XNjKn1-fGxQ
Message-ID: <CAOi1vP-FVKUUvQQT7=EuHij9uerqRvdrTQegMch4_JYQp64Qvg@mail.gmail.com>
Subject: Re: [PATCH 3/3] net/ceph/messenger: add empty check to ceph_con_get_out_msg()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: xiubli@redhat.com, amarkuze@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 1:47=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> On Thu, Oct 9, 2025 at 1:18=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> =
wrote:
> > I made a change to net/ceph/messenger_v1.c hunks of this patch to
> > follow what is done for msgr2 where ceph_con_get_out_msg() is called
> > outside of the prepare helper and the new message is passed in.
> > prepare_write_message() doesn't need to return a bool anymore.
>
> But ... why?
> Your change is not bad, but I don't believe it belongs in this patch,
> because it is out of this patch's scope. It would have been a good
> follow-up patch.

Changing a function to return a bool only to immediately undo that
change in a follow-up patch (both touching the same 10-15 lines of
code) seemed like pointless churn to me.

>
> There are lots of unnecessary (and sometimes confusing) differences
> between the v1 and v2 messengers, but unifying these is out of the
> scope of my patch. All my patch does is remove visibility of a
> messenger.c implementation detail from the v1/v2 specializations.

ceph_con_get_out_msg() is a common helper and given that this series
changed its signature and how it's supposed to be used, I wouldn't say
that adjusting the specializations to do the same thing with it is out
of scope.  This isn't unifying some completely unrelated aspect of v1
vs v2 and the resulting patch actually ended up being smaller.

Thanks,

                Ilya

