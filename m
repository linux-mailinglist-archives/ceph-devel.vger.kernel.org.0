Return-Path: <ceph-devel+bounces-2849-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB54A4CADE
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Mar 2025 19:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 531FC3AC021
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Mar 2025 18:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 986CB22333D;
	Mon,  3 Mar 2025 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="td3wpqRy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A01215058
	for <ceph-devel@vger.kernel.org>; Mon,  3 Mar 2025 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741025913; cv=none; b=pzo8bhCXLCFQdsOs8tkeTHalKB77LMTKWOcfxFa9Z4phbe6KbxgFHq+Z6orzd3aojTYSLW2HDwxUCXb9UInli2dSvwAHtJBM0Rby6An0doZz9dcAUTIIydaW0bdux7n9Va0mN0xL+fWZZsO9tP7uq24ca34yhvoa+G+Jf3qmIMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741025913; c=relaxed/simple;
	bh=aqBu5lgaIjKfB79ewU8DMYZH9ogDFAvumeNR3vcP144=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uJXXhXfg1xmvLF+TD83jaTsP6I+7nY/ASrATdIhAc2OmBt4M+c0IjJg77m0oUT7qZjwFd7yzpH7TEVcb6oOLqCNFosS6fBS/skIEkgY689/cm6xNYxFLnedGQa5qvGkSswAvYhkFLmlHugYkoqWxlodLMMwmt9dHxnINKQKvV8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=td3wpqRy; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-85ad9bf7b03so103422539f.3
        for <ceph-devel@vger.kernel.org>; Mon, 03 Mar 2025 10:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741025910; x=1741630710; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PvjzyQGR5WjOCFzCpc4mCzksbIOnD4wTL60DVSWvoTc=;
        b=td3wpqRyJzanGMf1wlmlKklI/DI4ZOn7mHdZRYD2IW1n0lZg4wzr7hBG9YHz7jO30R
         8dv7+Y8yVISBqbLhKKffi+4j5pEnPqlP1Pa1Ob+P8wTceBq2u282BQ1rQylPxObO4IWK
         i7Isi0J92lZZhKiUcnwy5kwtRdGidCr081emNE24MS0Bisdnri7t3LXMC/AaQ8NeRP8o
         qvy6a3NhY0i+kvftjXW6LWOMKruyWia2x5KoF8y0eJSyrCEL0SYXhR3/QDgsJXtpDY9K
         IMY6S9jDuyuZCE8VhAEvDIksyn1uZfsNHe7VwZdfl7tKuBsohDJgrDCUeRCxt3dBdbit
         qd1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741025910; x=1741630710;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PvjzyQGR5WjOCFzCpc4mCzksbIOnD4wTL60DVSWvoTc=;
        b=OEtxO7h9SdTF9LQdm1tK2vdxFDhe5ZbSWLoAd0WuaBv68SxMkG7XG82PS98LFyGEAh
         NyV9U9Hy+eROmMB1USA0X0WBr5KI5v88Ts5mSZ+n4JlBFOH48LZ/ptL2pen1EJpSn6JW
         4LZf9xvyPprQthSm1inu85qWidI6wKZ0RtMlEwmqX78Nl74BGUzRHW06vGJbR+PcX9LW
         qIJ4pUXisqO1YxIIx7EK3uxC3b85BgdG8AESHl3PNlq/xNy/sFDSN8yqbfkLiMQVW+DW
         uTvvavtEcFel77QqplgOZ2GUA1upHi6y06+SNrkI0QJuFFgfinmehNVhmvLfwe4hKxt0
         VX7w==
X-Forwarded-Encrypted: i=1; AJvYcCUJ+kLc6kAqdMsNCZFjBeE+wmTsTW1egE6ETLY+KIWUYZoUMPGMJDAcl7XV5l7L7+3NKyfTji4cyGAc@vger.kernel.org
X-Gm-Message-State: AOJu0YzcHxkdPS4WhoDNbfzlZWMJQV68l0t1+QTG/oxcI6Iw0tf2GXd1
	kCwIdFZjucKTD2FQYPSg3VaJ7bcZ2WToT3ovhd/Rv74TgFXXsEhQSjKrJyYMqjo=
X-Gm-Gg: ASbGncvM68go0uUN1pVYT2P96CYzH1DPd8NEribu8wwoV2I5BYgKXBGf6xX1yg3K8B4
	c0YYF6DSs0CIKyBK29pFdoW193cAJ/lR1hLBDET+i1FtHcPIoiSUq7c0WMyeuVd9zikZYe8XkEv
	S1qRszc+d7PH3bq77EDwj9CzjcBpOjDKCClVfuwv53E4gCBbRnZ90EH4wWZdLw8vt//DXbOnufO
	emxZodxi6CGRaqG6q2Hoz6dLT79ITao1YD5/y1tliKGGFiQnXaz7wUxVPpXW7QvVeo6C7wbswED
	sHPbjTb6Di8vS2Z5PTrvpjXZej8ONvjTXFbPHKJh
X-Google-Smtp-Source: AGHT+IFNdCaZ1XIhp2XJhaxfUE7ndUbdgMNH8GlVjblLMQhKUk1YKF0bz0OwoT+Q4yO5k2hF9QBXug==
X-Received: by 2002:a05:6e02:1:b0:3d3:e536:3096 with SMTP id e9e14a558f8ab-3d3e6e952damr141947255ab.13.1741025910102;
        Mon, 03 Mar 2025 10:18:30 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f09cac9f8asm527552173.39.2025.03.03.10.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 10:18:29 -0800 (PST)
Message-ID: <00cef2b0-5a33-4069-b0b7-96f65b6e13ec@kernel.dk>
Date: Mon, 3 Mar 2025 11:18:28 -0700
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] rbd: convert timeouts to secs_to_jiffies()
To: Easwar Hariharan <eahariha@linux.microsoft.com>,
 Alex Elder <elder@ieee.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Daniel Vacek <neelx@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>, Xiubo Li <xiubli@redhat.com>,
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250301-converge-secs-to-jiffies-part-two-v4-0-c9226df9e4ed@linux.microsoft.com>
 <20250301-converge-secs-to-jiffies-part-two-v4-1-c9226df9e4ed@linux.microsoft.com>
 <4c4b3d6f-64b7-4ba3-8d2e-d8b1f1a03a53@ieee.org>
 <d5035d88-f714-47c2-ace6-8bd609d84633@linux.microsoft.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <d5035d88-f714-47c2-ace6-8bd609d84633@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/3/25 11:13 AM, Easwar Hariharan wrote:
> @Jens, @Andrew, can you drop the rbd and libceph patches from your respective
> trees while I work this out?

Sure...

-- 
Jens Axboe

