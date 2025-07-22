Return-Path: <ceph-devel+bounces-3323-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE155B0E265
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Jul 2025 19:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEA8817C250
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Jul 2025 17:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BA527E7DD;
	Tue, 22 Jul 2025 17:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="BpTzgyIv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B509625F7B4
	for <ceph-devel@vger.kernel.org>; Tue, 22 Jul 2025 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753204105; cv=none; b=cL2P5XMGOWMJo2epPZaZnyPxo4Lb4s5EulsJWYQL9/yEX24ST49ZngIS5kXB1oH624c4I8kalIcsQ2xc9nT3lI+zcPHvssCi0MmlGSQovTIWJKf9dlvz0nEuPGkvM15q7hREKUYNNbjSc4nPXPZuEtvn6709et6pT2CW2dN+/eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753204105; c=relaxed/simple;
	bh=978GbEPG+xXIx1MSYHSlwMCgP2YjVw9X66Q7T0J611c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C2amae6rFG63wo/LhB/FZ1JSSPUCZNSLtxUAHJNagP+/bUot2iYJG74p2GvIhcMtF5uNrSFmRs/To56SQ+bc1sBS9kblEMoaFgTZasqgYxPntNNILxd1w9Is9lOBZujzLiUCAvqmqGmImIN4Espc8a4t29O4QPpOx4HwyK8GygA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=BpTzgyIv; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-70e3e0415a7so1436617b3.0
        for <ceph-devel@vger.kernel.org>; Tue, 22 Jul 2025 10:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1753204103; x=1753808903; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=978GbEPG+xXIx1MSYHSlwMCgP2YjVw9X66Q7T0J611c=;
        b=BpTzgyIvJ8UwX9DkRMd1Hg6FA8FCpYhBvaglYNUKPuS3ccQJaAhott9sOrHUVXUpqe
         aTsIAHDTaop+bIM2LbHf78psU7c5QQN2jodU2C1/03xULZCf4VJIxCD6oiKC3X6sGrnO
         As2CvLpbh51ahhVS6vrCGoYm9AK/Jk5SuLBbkC5Ig2R1k5xfwiiycumAduoJdjF75jKD
         FbEVL/yZnq+gMpWcsheC5SVOKi6kk8wt+3Coehqb5Cp6jBoeYufkadWZL5Dy9Phx1Poh
         k4euKKW2R+fyBMBL0MVdAWu4/lKYClFiv5WkthF7oOwrxgH2MlX9+sMmTCNeRn9eK6rA
         L20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753204103; x=1753808903;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=978GbEPG+xXIx1MSYHSlwMCgP2YjVw9X66Q7T0J611c=;
        b=A24Fsid1YgvyO69aOLuUzN4/7tveD/Itz/Iu4TibQSKDKItAuYw4tfYJmgUsIpRwyp
         CjnN4b+JuVtxA/dHjHysKnkRY4uF41boBIF+eUwPftqovLFZJHUQCmu4w6sgC9gbxaAx
         Sh0j2HKes3cgcvV3GXGHW7JwgWs6FYJQb/SVbbCMi+AJdeyrBDBV/+Bdo+qYUmD5cnXa
         mGwB7A3Ss5JA+LhnLKX76LboR8EfA6oq3N5N11UwFht2fV6NWMSrPJQDptTn1lYzFvUb
         In2Jr0jRuwu6Vv3ECVFmSxhbnlGRJKIq//+L1saT/aGJ85t+ZV5RjqxatjuVFFZs8Nvv
         I2pg==
X-Gm-Message-State: AOJu0YyuxGyUPF8ggNdpSO1j/qhc6QycYglkE6EFXpGT8renTgVm/NF3
	O+/ogF342yBPsxgFCkGQqfF4Bg33nfHObagccpaRBnUU7k1rTxxsq/Eaqkq4F+vRNMg=
X-Gm-Gg: ASbGncs7IVgUiSP4nPMYtaV7xyLi9rh/A3DD1mejr2UReO4gkeBf9sclxU08M3OhHGF
	H02o4E5dwU97N5ePCFzNq7vYQx+7rjrvO3YnLJqK3RYKLKJ+bBpgsQJ2ulK4g119mQUYYJcKMR1
	LBKiuk3UDyCnM/k0V/RW2eSHIGIeqB5HQt6O0dvyr0KurCBkDjMazet+N1qrUoK8YdrpVKcN4Qc
	OFNK0BoYNlTYhpChrmiwMJA60C7hgdtw3i9OVYf4OqGW+Opusdv0ZtlTkV7sMEQiNN5/AciStDK
	1nske3WwO9NZaOprBC7HWAGGbgxsQIswYuHx3vGYm51J+AHaobOGYdnNnBi4bWTegKvrSgST3hU
	jbkTRSAUkCRKvJrSP08ks9GSTLOx+7pUsmcjq6wyLI2B8nbObfi5RV3A+i+QyLwD1aiUwjg2zVP
	jXQM23
X-Google-Smtp-Source: AGHT+IGY1G3HrbiCpbrrdm7GLTE6gZs8zkI6sqGbC9NdngVg16dzHUoZ9jfWZuCOMN4WWlWR5iaFuw==
X-Received: by 2002:a05:690c:660e:b0:712:c55c:4e54 with SMTP id 00721157ae682-719a0a32c31mr66496677b3.4.1753204102464;
        Tue, 22 Jul 2025 10:08:22 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:7b5e:cc7f:ebd6:8d83? ([2600:1700:6476:1430:7b5e:cc7f:ebd6:8d83])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7195310b038sm24813607b3.16.2025.07.22.10.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 10:08:21 -0700 (PDT)
Message-ID: <cdeca96e29969fbac462acca4e6e2b60e103b4c4.camel@dubeyko.com>
Subject: Re: [PATCH] ceph: cleanup of processing ci->i_ceph_flags bits in
 caps.c
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Date: Tue, 22 Jul 2025 10:08:20 -0700
In-Reply-To: <CAO8a2ShpORYPW6XewdgaBCvc8qW=FJ_AwJj--foGJcx2UG9LtA@mail.gmail.com>
References: <20250721221606.1011604-1-slava@dubeyko.com>
	 <CAO8a2ShpORYPW6XewdgaBCvc8qW=FJ_AwJj--foGJcx2UG9LtA@mail.gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-07-22 at 16:19 +0400, Alex Markuze wrote:
> Hi Slava,
>=20
> Thanks for the patch.
>=20
> The fix for the race condition in ceph_check_delayed_caps() is
> correct
> and necessary. The systematic change to use atomic bit operations
> like
> set_bit() and clear_bit() with the proper memory barriers is a
> significant improvement for safety and readability.
>=20
> One minor critique for a follow-up patch:
>=20
> The refactoring in fs/ceph/super.h to use named _BIT definitions is a
> great idea, but the cleanup is incomplete. Several definitions were
> not converted and still use hardcoded bit-shift numbers . For
> example,
>=20
> CEPH_I_POOL_RD, CEPH_I_POOL_WR, and CEPH_I_ODIRECT still use (1 <<
> 4),
> (1 << 5), and (1 << 11) respectively. It would be good to finish this
> refactoring for consistency.
>=20
>=20

Makes sense. Let me rework the patch.

Thanks,
Slava.

