Return-Path: <ceph-devel+bounces-1523-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3CB492EAE3
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 16:37:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BC3B283281
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 14:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FBD16B725;
	Thu, 11 Jul 2024 14:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fs4+WMZ7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9056816A95C;
	Thu, 11 Jul 2024 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720708613; cv=none; b=LTGqIcb9N59wQ1f9rPj4+xu4pikIb2gEVJV3Nx/975E6jjiFXoOd/Yq8By0ICwSBjilFZ8CWuqHAFiUc7DbMnN8E42OPyFXt4lgrkcieym56x7lL+H1EdBCx8epeRHrNDJhab5wSF+RQf7r7y2dJXuwNI4zsOf7z0/ODP8+xs7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720708613; c=relaxed/simple;
	bh=4slNKHgU3sDBnSzdUljMVppcwxGiJhBU/AKQY/Pjy2o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VK6EkHBR2q2y7Fy5EjvLpfwLezSRA8FOvvXW97k2LFpI2H4fJsq7lk0EmjmG7mjtlN7TJ/RdlYn+EHaB+Yu2swsaW0z3FTtHOdZ6tZKfh2aOyq8Jr7fyGwUY3xqtIpZ46K22/KKGygMedL3OKOtZ7M2g976hyIZLiA+yT3qjtYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fs4+WMZ7; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5c477d97159so535707eaf.3;
        Thu, 11 Jul 2024 07:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720708611; x=1721313411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAc1FusjAxJkbPWpKrSy+SvGdBb2Dote+7JaNjWHCH4=;
        b=Fs4+WMZ7OoqAKT345HB97E8goYD8ng5kcuV01MkAOTnIeTEC1WSh/DHHCaoRH8sxoE
         2r5a2+F2FbHcwTuJpJdJcAoejSzygckcJ2TlSHb/j0BFjJIqV/tMMq680LIltpP+UzOq
         Jv/FO/KF/gNhk81n1EmGZojn4/Apv27fdm0hY4wkxjt/PE+LamI83xWNcpvFyuIa3jTW
         jxppkyUQvdlA0N1P3X04Ly1q5n92kR7MLcoXComyxxG227XVUPoKnPH2JX9T0YadIzGG
         5u7A6AIADfB7d9sAM+IVYMMM17e7kTdHnGkZWb2m2E4hjaWL/KOat5qMyTg7fZgmeoGN
         BsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720708611; x=1721313411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAc1FusjAxJkbPWpKrSy+SvGdBb2Dote+7JaNjWHCH4=;
        b=hP7HFIyf+U8Yyg61mkJ8Ps+AwsQwYi7kkzg7g0IsD/3XCt/RSwyaxJuMDSIk77aqNN
         xKfVAM0KZQiWkqPl9k8S3QKWksCHQhUDHlssq4V0GRNp5CKo8lUIl3yeeBGSnaATmWWl
         0kyypXpJXzuYiXPAZcZkgChM0kjfVZ/7RCZX2rUCcVfwui0oGYX+Kzjo713MC8YrbOT/
         ELGSsvPIoTi5VyfoB6lh8onLkrLb/UDVb8XFDe8caCgIva6uo/9s7QvKl4Tytxh3Pl0m
         a+xiGDyWzkUl+cwHyPsZ3UmhI9qowr9hyIKk0H9jdnboorhW0FQAY5pGPBB9wwvr2k0r
         n3Qg==
X-Forwarded-Encrypted: i=1; AJvYcCXSSZ0MseLQiGV44MmUKV80InG0DS1X4+P5T8gWPzUzim0Qp/vFTLDVPt76jY3LeQ6LrZjdFIHIZ8WFtfSSI9RX3ddj5d/r0uyabqYg7DFkWveqsvBP83LO3Nnv3MEAvzZTfkE9CsjloMMtGpPCKPdT4fCjfVzEPThsi/dxU8S1rg==
X-Gm-Message-State: AOJu0Yy3X4Q2+N4bVwKv540VSYqdKWgtL5kfLw95i7mW4D8SsJ/fJubi
	ePLaJNDUAOpwYiijQ7ind5jlrwSU3fZiEewBMX8hQ3Uv11b0Z6KQmfoD9EGPRIAx+8qm6CzpNAj
	16XTClp2g3N8GOtteicahnUG1EYM=
X-Google-Smtp-Source: AGHT+IHlsyKAbOPlpAgM9FeBXzfBx5JJ1FLjxH9PVvcAYjcXVwTsf5ATIJYyplaTlDjKBXFfWXGDTYhTdKC7NWppfGk=
X-Received: by 2002:a05:6820:1c4d:b0:5c6:8eb6:91b2 with SMTP id
 006d021491bc7-5c68eb6929bmr9709299eaf.1.1720708611592; Thu, 11 Jul 2024
 07:36:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710-kd-crush_choose_indep-v1-0-fe2b85f322c6@quicinc.com>
 <20240710-kd-crush_choose_indep-v1-2-fe2b85f322c6@quicinc.com> <20240711133449.GF8788@kernel.org>
In-Reply-To: <20240711133449.GF8788@kernel.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 11 Jul 2024 16:36:39 +0200
Message-ID: <CAOi1vP8PcENtRZ3N75FebVEH+R6a1dnV7nnYdsUgggk8LnV+oQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] libceph: fix crush_choose_firstn()
 kernel-doc warnings
To: Simon Horman <horms@kernel.org>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>, Xiubo Li <xiubli@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, ceph-devel@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 3:34=E2=80=AFPM Simon Horman <horms@kernel.org> wro=
te:
>
> On Wed, Jul 10, 2024 at 11:10:04AM -0700, Jeff Johnson wrote:
> > Currently, when built with "make W=3D1", the following warnings are
> > generated:
> >
> > net/ceph/crush/mapper.c:466: warning: Function parameter or struct memb=
er 'work' not described in 'crush_choose_firstn'
> > net/ceph/crush/mapper.c:466: warning: Function parameter or struct memb=
er 'weight' not described in 'crush_choose_firstn'
> > net/ceph/crush/mapper.c:466: warning: Function parameter or struct memb=
er 'weight_max' not described in 'crush_choose_firstn'
> > net/ceph/crush/mapper.c:466: warning: Function parameter or struct memb=
er 'choose_args' not described in 'crush_choose_firstn'
> >
> > Update the crush_choose_firstn() kernel-doc to document these
> > parameters.
> >
> > Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>
> Reviewed-by: Simon Horman <horms@kernel.org>

Applied with a small tweak.

Thanks,

                Ilya

