Return-Path: <ceph-devel+bounces-1543-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE3F939679
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 00:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 667B41F22E3E
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jul 2024 22:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89F7646525;
	Mon, 22 Jul 2024 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U2espImN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BDA3BBE3
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jul 2024 22:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721686902; cv=none; b=Wv/Su0TscO3JzZp49msQ/Pa6px7gRA/CjkWFP+MAVFfu1aE1sEW99SlPgRkxmaz7TF7IMY2unkMF1dDgQ+NBLaeK6dDzkZ0IGsH+EVZdoek86ENuoHI8d7BU6g2lSTbkXGF/UOEewaCSjFQLu+/EX0iADNYHJwqcV8PIfOUR9+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721686902; c=relaxed/simple;
	bh=34HtSC4duPhf+8JCQbGf+fUCRFdJigXMf/wWHTIHDeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nF4xU+dqT/wyPGBpWG+w8gywNHQqwK2dUcQ/Yb+BJMHigDRjirG1RQ2sofF4w/l1QxsloA8mJM1/gbft0UjxWA0TQ3uSutbq1eqZIqz1tuJZMK+yXAemA9Akh6fcfWQg0q0i3N5mZrag95kN1PUloIZYzIaAp6HkVsZfwMU46PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U2espImN; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70d19bfdabbso52210b3a.2
        for <ceph-devel@vger.kernel.org>; Mon, 22 Jul 2024 15:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721686900; x=1722291700; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gRJ2uTLG4AE1W2r135WxVjYfrIn0tz9jHJj9trzpqw0=;
        b=U2espImN/kPsCHZbznGWrO8qY5uFiuMkyF5juS6aLqDjSgJ7FJzi7fEJ1Dy0V7PAVi
         gBfSnQgp30/hARg/uio5lqpLqJVaPmlFBRUMFBv8+r+Hm6OJmyeX7YI9HwqgXlymjx4S
         c5LN5YKsrMOWcTi+v2ogYl3Vo2F7oxhzKtwbzAttGrdux8szT/DebBdBjuBD7XjZt0kP
         J2TW30lvPN6JfO1C6w4ELbER3oszH5Sh/PePfCrYaUo3xUs4nz6iqtib/PkmAEVTGiJE
         ARHqFEFBYeAh6TkTwknAigQi9Rbo9ucwor2WorhalcwIiHbA6wQNKh9s9Mz1iSdgFokq
         hHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721686900; x=1722291700;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gRJ2uTLG4AE1W2r135WxVjYfrIn0tz9jHJj9trzpqw0=;
        b=aF1aKeFG+nuUxegH6Yus0FRizk70wMkxi5ERmDK65iynorYLrwdzCPyrkc6y/MMFLN
         6HAiiZtIHlmWTuI6wSG6h5JFr+Hgv2KwPDSPG+9VtMVxhzeUPpVwThDoyRstj0vHVHWm
         Yl/KbhqTVqbD8BOAgyYzblkTAE4ItQiPoid/W2LW5ykQTW+559Jb3WNAJTE9WnTvamCw
         uLnGjfE9Y69ecR9neAjmUDJRnUhXMmJl72IQ+wpCJQifrbsOFrWIiAfQUn3XDDnIbVMI
         6jV68q3WEsz1G9LM7iGtd+YcGbcu7olwE+8q4KUH908j4KEnSC5WG+jcNDisf+izFfb8
         lIOA==
X-Forwarded-Encrypted: i=1; AJvYcCX4QuZJrJn5tfjcGmPmU/DgRVfuH+PrtAhIKbzt9F4JsZwEtCJa/8kfnB43VEx+Bg5St5/m7MbbdRJdZyAQNi+tGyKMT1zur6YZ+Q==
X-Gm-Message-State: AOJu0YyPJ2aCzMcNESU2LVcbLMbVDYRIK8WGoAaxxbWYia0zJeNZCS3x
	Jh1KQMOS7XGrylWwyXJc+8RzPFoanWzluDW6zkA8slPhK9WK5NFdgobw/D+nRlc=
X-Google-Smtp-Source: AGHT+IGScHD6XHoPrstmVFPw+Xo8947sWS5UFvpK8ufwAvqfdOvxadY9ZmmXoO25QdpiwaLvvRLgSA==
X-Received: by 2002:a05:6a00:6006:b0:70d:2cf6:598 with SMTP id d2e1a72fcca58-70d2cf6127amr2260050b3a.5.1721686899902;
        Mon, 22 Jul 2024 15:21:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70d1fc869cdsm2974888b3a.170.2024.07.22.15.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 15:21:39 -0700 (PDT)
Message-ID: <0cc50a53-fd8f-433d-bb69-c9d3f73ceace@kernel.dk>
Date: Mon, 22 Jul 2024 16:21:37 -0600
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
To: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240718084515.3833733-1-ofir.gal@volumez.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240718084515.3833733-1-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Who's queuing up these patches? I can certainly do it, but would be nice
with an ack on the networking patch if so.

-- 
Jens Axboe


