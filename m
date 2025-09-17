Return-Path: <ceph-devel+bounces-3661-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFEECB81C74
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 22:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB63958701D
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 20:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BA129BDB5;
	Wed, 17 Sep 2025 20:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Li8TGEPa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36F824395C
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141189; cv=none; b=CGTJt+HvKvG7Vyx12WmHl2oKMmfBGlfdLnpEJ04LXSoQd1jtn8V8gknnSDfwmoDHqPrzhEpprwA20FG6wL3xv65fDlQykuzhbCeSkwE43/DyzN76FlwXgmXPXqgTfR7hSEaKmW9VuvstS9Q3VYZuy7CVqSdNU10ni5MpyyduY4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141189; c=relaxed/simple;
	bh=+Y0zPcfwWdxA+c0s4fHg8IZujVM2iirb8dLcM0lSQQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QR42ReeXffMl55+v4LR/YuTFazwlHroXL4Hx/GEfl9c741xxmql5QAgkFMxkk/+/+9wKyj+RNfGNx0lhQvwM0nRW0lyDf15CUy9fjWYhEVHodbnBjCikRwA/1l7twC3Tx1oKKOIJb7GTvuiZe8MIs5ZACafV3dXuj74O2CnAGcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Li8TGEPa; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b0418f6fc27so35706566b.3
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758141186; x=1758745986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2/zE+U2NdiGVEzz6yPQL135dw9YRWvNuaGSRy0m5PM=;
        b=Li8TGEPa5mRkYzKa69QSMCU3Z17Ryqkk+O1FKdhVu+4KoxIq35Nnk6KCgNlD2IBcNr
         1elxyciqjz7zE0Ap4MFjApCsT16WjOMDUK26PsCVUbhlrAzKzKhUZZtwrTtS0KTMKsIN
         iUD8ta+45LhuMwKL2sWkBVsHkYIbAeXCRb1gjcymBL3lOZhHo9gMwVTxdytYZtpXc8qx
         1Z0Ug0nd9lurU81WyzHst5sStYc4UzFRd2HtwAupMWJambTIAKXfNSnzfSLe5VPoZjKG
         v+1Yu5/Bd+5alFV/DRAVThz/kB7lbiY+2/ODnc9PgBJ62+lsVGrK+6POvt76O7Oef471
         l2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758141186; x=1758745986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A2/zE+U2NdiGVEzz6yPQL135dw9YRWvNuaGSRy0m5PM=;
        b=McrAqEH2y5rTcbYFKffvddlIPOs15pu7cDUEWGgltiICnbEYiAqMuj2zr9ofPl5+zg
         WKLRYeF0pk4J7yuMUjPuse93B7pnirYPKUgh5EsjnMVPwAxwEKbmSXh2nmOe1sdvTjsa
         FJSZAAUZbQyLbCwp/cqP99+sm0fkTzlG7Y6xwl9ehNqCQNb/mxkmQavnuvdPC4TUmR7s
         yXwcTJU0NKf7+AoaTnjCmU24kMjkB0XhhC5Vm47gWuGaXkQgcpOfs6QEhKA4HOTnFzCc
         uNzNt+2nDlpis85NLfJ9cQHekt50mfRONmj1G+iskmX7yP39CxLqvcrCQl4XPatfgo7b
         u9rA==
X-Forwarded-Encrypted: i=1; AJvYcCXh6DD1/UnoVJJp0O5TqyjLWv41V6uHL8rtm2vI3fZZVELJbCucw7oIv0FWDy9oOdyougo3SC6eD8N7@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw0JqpxXCQdPf4WPUr8fuXqFH/HXE1v5ErdLIn2K5BrBIK5xUE
	DKe0zePgwU9aHKmnr3JVP5VsoHpMMwBElyCsZ16t/Ag23Oh4MEUokk4RS9rVKshwFGOyVde/DOa
	n0NNVDWCmvk+4KvojYnNsgCbIb6wSIXSlXla4B9wEQofXv4bxewum60Q=
X-Gm-Gg: ASbGncvhxXI7OZ933ZHxWrjrQdB82R8KL0mqIT6JV4hEPYPVxYCilFTTxok6PJYf8fz
	QRgon4rNEassJmg9W5mKSQj6JZsAGT4rfq19K3VyEiSob0sDXP4iL/SsGSsmGKHIXtgOfkrncpZ
	yl+qhztAqXSG3UHi0NGB+MZED6KV67XBglawKFrnGVRC+jnazS4RPrBRuXwG4DeJU2pXTKlperP
	QeMxVZXg1yTZhfAH6MJz0WQXvqvAEXYwmeVOMrEsEGozmMGKfEXxP0=
X-Google-Smtp-Source: AGHT+IH9oujhhWDrl44RnWA34Ua+LIz3ygyCfay2po5pFCbVcM1XbntfX9EHMI/yw132NXrBxBGW0Ue38XZA/MmI8QY=
X-Received: by 2002:a17:907:3f9d:b0:b04:2d6c:551 with SMTP id
 a640c23a62f3a-b1bbbe51362mr375134166b.42.1758141186331; Wed, 17 Sep 2025
 13:33:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAKPOu+_WNgA=8jUa5BiB0_3c+4EoKJdoh9S-tCEuz=3o0WpsiA@mail.gmail.com>
 <20250917202914.GZ39973@ZenIV>
In-Reply-To: <20250917202914.GZ39973@ZenIV>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 22:32:55 +0200
X-Gm-Features: AS18NWCqxCzXv8eyHW2GR-MxYUrgmiPK3CG9A2laulzc4bLaAxYR1-YXcuok9Go
Message-ID: <CAKPOu+_KWSAHF+U9UFrON3nugt9mQQcwCifCNbBxkKQUEnFF6g@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 10:29=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> At some point ->kill_sb() will call generic_shutdown_super() (in case of =
ceph
> that's done via kill_anon_super()), where we get to evict_inodes().  Any
> busy inode at that point is a bad problem...

And before that, Ceph will call flush_fs_workqueues().

But again: if this were wrong, would this be a new bug in my patch, or
would this be an old existing bug? Knowing this is important for me to
understand the nature of the (potential) problem you're raising.

