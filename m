Return-Path: <ceph-devel+bounces-3881-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E161FC0E681
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Oct 2025 15:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78CE7402D83
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Oct 2025 14:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 737F2308F05;
	Mon, 27 Oct 2025 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EAHs/7Y0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB347305E3F
	for <ceph-devel@vger.kernel.org>; Mon, 27 Oct 2025 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761574689; cv=none; b=h+cEQMw27km67IQRfaYZHZVU0ugfvvrNRlLkwa5jvXoa3YRRumMd4HgyOtsFprxtXYC1cn9cPWrDTKQj87ufCu8knpmH9rWvQ8gi9mmCzPCBv1cD3zmMIsrn7q328eCmfiB7lk/7oz8K3Kdifa/wtvhdTASbOcSr9gRtooGnivE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761574689; c=relaxed/simple;
	bh=Dn6kprdecpTUxGqwDMYcg8A0ejBALzUE1/ER6YNvJuY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tpr1QYICXHRh9NWcHw0KOrg6VmjaSMp3AkLsO2AghDJXCekS9kZH06ICmB7JIAYy9YTaK+e4ELCkE+ZKu59jt+lJ5UikqTs0zo0y+e+JVF/e/hIyASo8lpRryO1f4zzsAgCBGevb58d5oiz5B9bQcQggcCbkxyYIX8r4WGKJk/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EAHs/7Y0; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-475d9de970eso21709055e9.1
        for <ceph-devel@vger.kernel.org>; Mon, 27 Oct 2025 07:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761574685; x=1762179485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OWeVQ4AtgfB93bgZfN+1XmqssXEaSbhn0NZTenNXkU=;
        b=EAHs/7Y0W95u/xuMGDP5awgUUSigL4xdhvGtWOJq2PBc6tOdaUHNfRO1iCqKNIuEKH
         jBt3F1C9qFbyasiK94+aM+DMFQxHV+JeMVPkPST+MYHLEUZK94N2ZOntiMjBHbi/HvJo
         3pRTkdeQbk0se1BLUhKKFHOTBtf1cBa5LMDfQmAF47CPc4gein+Z1iy20yqoYh65N8GT
         YdZa9baC/YBMD+hj89ffnxU7vl/SPSF+8fNKeaMrlY+vlMKCWecoCjz7IJNNHg9tWCO6
         6GUzO4FkpmnB7d3y+dhQXesci45jlprdmlH3jnSftAAAdRolWW/SrO563FS35NYwmvca
         mpgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761574685; x=1762179485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6OWeVQ4AtgfB93bgZfN+1XmqssXEaSbhn0NZTenNXkU=;
        b=pJn1riULOkYudJTlo1Cu3Bhseus8rMjY+fq89eqADy2trPGFpdcmxuHSV9w5VFy/N/
         X8vpP2FcxD/gBm/GzHZlQuTBA1UXi/18hYvl9zuvbBxn+CsTW7Mm9z4NN9ObU5BGvUdz
         ZX2v9hXxx9/uVVVwr406t0XIPI3gGuFUeqIG9k4vmnV0bszbgmvk2nTyIitfewXAYB9x
         0UClsyN9lAXT1PwPB3Xq6x7XtZLMC+yjDO7a0tB4iA4AI0sMTVJx5qR9KA7lnl1mzqsD
         i0b/5IgDm+LyCs1NBHcfrOU9oRGdmF0yuYJrQWhLOy+KoWqxRgTp1iY4HWE9TrqBpQlL
         cokg==
X-Forwarded-Encrypted: i=1; AJvYcCU9PO/+r29FeJtuRu4BbAI/pEdwCTQtxDmD77RLlTA3rIV3i13vNtxxdCmtNshakBRv0iG3yBWb+2Mq@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbfar0wyh+uwM1FUAOu4DbpC4UvPKgSBi1PoMWrzB3s+SEbGUb
	O2LgCFFzqgLEk9Q60dLrMCVJmjF4vpAYPyzeWDR1sDnK4IO2/pgBF5n2
X-Gm-Gg: ASbGncvr4PWfGwG9WqagYylj9giSytYEcEkTplU2d9jhcUgg5Wxz+DOyrLqnjHAeYcB
	BFCi0bwOzEFDAnHEZ+b6a6L9rYllNSUNW2bbMoVN74YURezjW99y8usBzoLa47uPYeqWgmh8ZrB
	t7dWIoIOXk50jXnynO8g1XhwvJxDVfGAjXIOwnDyKlhLbB/jxcQNQy1CQJE2Vrgl/ce5/7TcUpk
	41MSEaFyGoz8FZBy1tgXVDWFQLL2iMIc6QM9R6Xmafxmo4AkQL8axv8sSxfvzkcalNWGTXjIXRQ
	gAUp1fIG5+mGuox8LXfBVBvAoh8INRoblMqT0ZYrkGASxgwkjXsckTAy5Hd1jTDB/mXR1X2CYnW
	G+gdeL2M8cvLikxreraU9NeN/1dgwNHjmsql9BqcStX1sw/dpGQQCL0U7/YOTHczKsArShtKR60
	K0QfUs5Csg/Otrhd/Sy1fSEuZDa8jIe00qfMgaDNEYZP8+a+r72AJd
X-Google-Smtp-Source: AGHT+IHOC4zgG6OF1kjm4g+wN+sLLGwPrLU1lwZ+ztIlqe61AFOMk+PmnLjf3OTwF1E1sL0nyHsaLg==
X-Received: by 2002:a05:600c:5493:b0:475:e067:f23d with SMTP id 5b1f17b1804b1-475e067f43fmr57939265e9.25.1761574684773;
        Mon, 27 Oct 2025 07:18:04 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dcbe5587sm168380565e9.0.2025.10.27.07.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 07:18:04 -0700 (PDT)
Date: Mon, 27 Oct 2025 14:18:02 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
 jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with
 reverse lookup tables
Message-ID: <20251027141802.61dbfbb2@pumpkin>
In-Reply-To: <aP9voK9lE/MlanGl@wu-Pro-E500-G6-WS720T>
References: <aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
	<CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
	<20251005181803.0ba6aee4@pumpkin>
	<aOTPMGQbUBfgdX4u@wu-Pro-E500-G6-WS720T>
	<CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>
	<20251007192327.57f00588@pumpkin>
	<aOeprat4/97oSWE0@wu-Pro-E500-G6-WS720T>
	<20251010105138.0356ad75@pumpkin>
	<aOzLQ2KSqGn1eYrm@wu-Pro-E500-G6-WS720T>
	<20251014091420.173dfc9c@pumpkin>
	<aP9voK9lE/MlanGl@wu-Pro-E500-G6-WS720T>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Oct 2025 21:12:00 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

...
> Hi David,
>=20
> I noticed your suggested approach:
> val_24 =3D t[b[0]] | t[b[1]] << 6 | t[b[2]] << 12 | t[b[3]] << 18;
> Per the C11 draft, this can lead to undefined behavior.
> "If E1 has a signed type and nonnegative value, and E1 =C3=97 2^E2 is
> representable in the result type, then that is the resulting value;
> otherwise, the behavior is undefined."
> Therefore, left-shifting a negative signed value is undefined behavior.

Don't worry about that, there are all sorts of places in the kernel
where shifts of negative values are technically undefined.

They are undefined because you get different values for 1's compliment
and 'sign overpunch' signed integers.
Even for 2's compliment C doesn't require a 'sign bit replicating'
right shift.
(And I suspect both gcc and clang only support 2's compliment.)

I don't think even clang is stupid enough to silently not emit any
instructions for shifts of negative values.
It is another place where it should be 'implementation defined' rather
than 'undefined' behaviour.

> Perhaps we could change the code as shown below. What do you think?

If you are really worried, change the '<< n' to '* (1 << n)' which
obfuscates the code.
The compiler will convert it straight back to a simple shift.

I bet that if you look hard enough even 'a | b' is undefined if
either is negative.

	David



	David

