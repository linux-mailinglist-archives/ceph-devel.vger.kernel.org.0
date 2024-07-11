Return-Path: <ceph-devel+bounces-1522-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B0992EADB
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 16:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4ABCB2588E
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 14:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 470B6167DB8;
	Thu, 11 Jul 2024 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JOJ8+KKJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F6E5477A;
	Thu, 11 Jul 2024 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720708575; cv=none; b=GCgNGsa8ZqU9PvKEWbh4Yv3G2s0J3ZR+X3PQ7QMs4kfDchfBCRhgiTBzvdMOQ8w87zvUGCvQGQ15nGYpAqoJijCbMuuSt8M7f6tcX9m+5Pe67vtEHwJYkeLOAj+HsSs8jmNpHwESXSwKncgDNLDYCYxFlAkbIF5afl0QU0X7txo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720708575; c=relaxed/simple;
	bh=LfEu9sb6Z+gel615ImLHeuJjyLCTqsRyAeVtCFQG56Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uOoH1Nd755WnHRlqyk7G6vsl+wph1IWLV/FLvTDTmixV/hJiOYOiwIVHcH14LFOr9x39GuuHJl1+Rb1xJxciHzhmYyYt8eyv241smjKnqldgAySDoRZHNMK7FcOw3m1RmxdXQPMseotfTXkh5qsl6Q00bM+Eup4wRn0zJJe4R3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JOJ8+KKJ; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5b9794dad09so470464eaf.3;
        Thu, 11 Jul 2024 07:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720708573; x=1721313373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+PqPRglT2FHcXxhn+n2H1tP06M07i0/kKzQT19g7WU=;
        b=JOJ8+KKJOk/O0UyVlBpAJWtXQAtSqnoOiZ2pQYM8xe/6V31Gz9lVIMcbpKK+LAskmm
         7iuZ3Or/JgVn2FaG0mWf1Woyq8UAQnOnqx/SZPkZ2JnaY5cY6hMKD/I3TMgaIXRa6Mpz
         OSCQZduL4+W19Jzu3cPRV6qkiDpMZRa3L2GoV6XD4C2nCvqk0d6zNhMha+vGXklonc0u
         x/SF4nozUn+pyJw5wcYp0td3KzS6qJ8bUA+wVXSvYlcTV8vjlTSbr8EFnCz+EVjkS0MU
         I9bNB66mMrFwjVjdAinQ3iDEXhpC+7TAgAFVTW1/iPB2OaPeN0JCEQ7KnPxg4A+N+9c5
         v+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720708573; x=1721313373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+PqPRglT2FHcXxhn+n2H1tP06M07i0/kKzQT19g7WU=;
        b=IVA6fwai3sC0+knpbOboobPG75fE/71XS6vCTryYiU7PwmCWo4y2GLkgoQgbT/gOxs
         S1HgxVbo6q0dRhw29ezg5TBATFLjwMB/l2lYp5q0vwmuhEuUdAXG1FUj1a0f+ode5Jw2
         esfilM/KXncBrljRju0EOmK2d2p1clurv2xLeV8hlaC0CvFTrU/4fAL9eA5miQ6gStah
         mkTiROp6AJ+5Blq0e4aQg1QjtAFtxcYPJGYmUxOA5KPSTBNNg6IdUmN3B/tn8qakjr14
         oF3l2WSllDny1jIknjMyjY0G5+8Wv/xxamBzoBhi2aElK3O+IJ+TA4n+nTnlu59VIm9E
         R8OQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbzfnaUKmzSTUukLrwahExl3VeEs4+MCXtQmV+ly6zydHKCaFqcYSJJ6ybkxGYMMUv7hQYA1qSqpzzQTt0htkA3u9/tRRXaHaoJWdlS3Z9smD7hd2Q9z8O5lZ5+vjUGkK36kGIiPT3OoWvsUw3Pz8Wn+HwCTSPuBo21mXpm5yTTw==
X-Gm-Message-State: AOJu0YxuEHXZ/hZbeHtPLCP4vRSi9rjBF6UqSBlzCzc+4ZjXdJSEiejh
	d2f9+P8PFfcY9cfJ9yay1v07Y619Ml0eXFjuk4kH/qB3qOVPLgIcbiuQZk1QOWzzY8ylHnMd+cY
	jhEzFX4hbH16WTQQn2BSEc20SWSZJIpu3
X-Google-Smtp-Source: AGHT+IGtTQquLNTbMYd9rOgNH1oOM2R3SJRK1YZxTRtl4EZyBB7ADAwRP9obmzcbsrU4h8aPdW4wT6MZ5Y8IkxrjRv0=
X-Received: by 2002:a4a:51c1:0:b0:5c4:7933:951b with SMTP id
 006d021491bc7-5c68e0c7128mr9395294eaf.1.1720708573493; Thu, 11 Jul 2024
 07:36:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710-kd-crush_choose_indep-v1-0-fe2b85f322c6@quicinc.com>
 <20240710-kd-crush_choose_indep-v1-1-fe2b85f322c6@quicinc.com> <20240711133430.GE8788@kernel.org>
In-Reply-To: <20240711133430.GE8788@kernel.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 11 Jul 2024 16:36:01 +0200
Message-ID: <CAOi1vP9VRSq1TGZG+NmsDdtHx6rximzqqGT7waDHX2i4Fbyozw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] libceph: suppress crush_choose_indep()
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
> On Wed, Jul 10, 2024 at 11:10:03AM -0700, Jeff Johnson wrote:
> > Currently, when built with "make W=3D1", the following warnings are
> > generated:
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'map' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'work' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'bucket' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'weight' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'weight_max' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'x' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'left' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'numrep' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'type' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'out' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'outpos' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'tries' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'recurse_tries' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'recurse_to_leaf' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'out2' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'parent_r' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or struct memb=
er 'choose_args' not described in 'crush_choose_indep'
> >
> > These warnings are generated because the prologue comment for
> > crush_choose_indep() uses the kernel-doc prefix, but the actual
> > comment is a very brief description that is not in kernel-doc
> > format. Since this is a static function there is no need to fully
> > document the function, so replace the kernel-doc comment prefix with a
> > standard comment prefix to remove these warnings.
> >
> > Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>
> Reviewed-by: Simon Horman <horms@kernel.org>

Applied with a small tweak.

Thanks,

                Ilya

