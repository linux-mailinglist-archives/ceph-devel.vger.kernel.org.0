Return-Path: <ceph-devel+bounces-3311-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C4592B02370
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 20:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8205C7B4F9B
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 18:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54AE72F1991;
	Fri, 11 Jul 2025 18:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dreamsnake-net.20230601.gappssmtp.com header.i=@dreamsnake-net.20230601.gappssmtp.com header.b="Eo8mbUkj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656AB5383
	for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752257798; cv=none; b=ih8jKDrKuFk1Dsl8xj1+b7c/D1owenrUHvfPB+i/tUEKJJiUKPEk3jKpsEujG0Z73iVy5jgMXNNy042QZos11QzdF97GOJnqS9fJTRH+XoBzENB4afXVA3lRlCEQJQfPAjSsx34kOqsCmc66uL2y2BlPsJiBVYyQ0JizApijKno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752257798; c=relaxed/simple;
	bh=XnonoRTUCdQXoqTME+OOEIsi8649sYvKiz+gCBW+PSA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=apeVVPkHxoBA5B/YPBN5PLzGlEQUrVUmZEx12tlMREVtcOYbORukaf/KcYUqfBBtOKYPLtqa6AHO8eN8YpcqnvNz482tbrBn7KHVkqG5eaZiX7fzdWjBWVqYtcT3uaVAbGRtT8si3r/9fK7KdcR8KOl5ioK65Mn7aIAhF2eopFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dreamsnake.net; spf=none smtp.mailfrom=dreamsnake.net; dkim=pass (2048-bit key) header.d=dreamsnake-net.20230601.gappssmtp.com header.i=@dreamsnake-net.20230601.gappssmtp.com header.b=Eo8mbUkj; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dreamsnake.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dreamsnake.net
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6fae04a3795so20764816d6.3
        for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 11:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dreamsnake-net.20230601.gappssmtp.com; s=20230601; t=1752257795; x=1752862595; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3RcDQJXkAbf27RSQ5rvtYkpaivKAYrpOGa2UChzUMM=;
        b=Eo8mbUkjm7MpQeHtXiJFi13vdE7NC/UzM9d+Z8KUxX92Q9NbfnPIQzuv7YOzoDbFzy
         MmHiG6vM4S2JyErPqcdaBgvwh+PwQWrNK+smlMHBm3yObiAELwH4XaaOt238rB3u+CQX
         Tqqnwlzm6UDTAQ4isBzVcIObZsVUFqeQxhxQsiBNiZmf8jYYF/fyy/kk+7ZeXvCON/1I
         8Vtqe1RRPBZr+S9W5/Lo6CVZ8M/+T66G4+XGGac3V1RDExkfqoAKdmUMh+EIgCmNaCHo
         SDHSPF1ou5zT5xygwzObUrmZXHiHXNqJ+FkI1kGtGbG/PbvdDhDTWLpqSyWgpROZGAJq
         LGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752257795; x=1752862595;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G3RcDQJXkAbf27RSQ5rvtYkpaivKAYrpOGa2UChzUMM=;
        b=q8thRVCqqosPhS2AW0cF0XVWRXkH6j83bw2f/9FdIYjE6xMti8z8YcpEIT0Y26jYnb
         DKzrT6Zyqpx7R8YVMaweJTuSFb2eVHe+HuyMsPslQ3jjSaIW3DpSnOtbuXIJaPctM/rw
         wXgdWGM5WsQVhh4JmSCk5bCWTVBd3wCJAr5Dv0YyQ7Fno1Q2wBziQJ/+G0tkppLQyvJ6
         h0e7h6nQQ9YL+6TwVqTYhMjUZxEpPf2ZFCn1AoE0Q/l8b9m28Qtb/6hWd2/0smXvYNzt
         mSSNmxWZ0BRHRrTIrZjFEYW6f/YExs6zbZZ5pD2tsIJnQTHV/pwTghkZ5eSy9ZMG4E+x
         7A5g==
X-Forwarded-Encrypted: i=1; AJvYcCU7ba7VCseDkxznso8lSqYsiC8U9ktgsLlHMjuefxLfJSIuloR91W1DTJOuYQfwPK41Frb/RJebE1RR@vger.kernel.org
X-Gm-Message-State: AOJu0YznOp8mDwnJbnkOdSyConWLKVqE5/D1PewKIO9ThX2Fj/V8laaf
	y9CsXbAaXscjd7RpM4+3shVO5rNJ6T8vAsKYEF8yYgmw35Wn/bnl7Hu7win0D98RcGpcG3KQiLB
	FXw==
X-Gm-Gg: ASbGncu3kzGbcko816HaQnHVwZQr31CcjbC3cfbIfMYEm3pR6NJKbjjxMlmCHvfJwyD
	znCLaD3rPIG6tmM0PxnUOAh5gc7teiADxyiTgL4jF8Fo1poNveu1Weg7RIuyK16JF3Xh/CdDHtC
	Im852bTt0FMSeUaH84Lrw4VNxTLgz1V5caeFN9x8ofs7Czm3EEX9DPuDxq00AjAlJDRpGlTOf8D
	3fI52308uRoiDGOr5uMP0jdgJpzhblcR0RNxOxuxKRevAQbZrcq0KlE6c1ScZST365GOPBtbTyV
	GOODWKaMF3oe7Dfbp9MOAjijzF5YTxfNMQ1TEc9XMy5oGZnp3dyenku3Bj5/utbYESBiaegRR8A
	Rj5Nki4igeUpCS5aCDEVitehvDZ63AEGYdkngmhru3OlZ
X-Google-Smtp-Source: AGHT+IFym26GDJy1up4g6pxeWoluaePH3qG3f6kZL9BOah/R5qOhNW3vcu9i1puZ92DGOWkdJ/5wIw==
X-Received: by 2002:a05:6214:258f:b0:6fa:d956:243b with SMTP id 6a1803df08f44-704a39bb51dmr81180606d6.37.1752257795280;
        Fri, 11 Jul 2025 11:16:35 -0700 (PDT)
Received: from smtpclient.apple ([2600:4041:403:7300:494:33f1:2212:8db3])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7049775443esm22516566d6.0.2025.07.11.11.16.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Jul 2025 11:16:34 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: discarding an rbd device results in partial zero-filling without
 any errors
From: Anthony D'Atri <aad@dreamsnake.net>
In-Reply-To: <bbb5efeac49870dad9783e30df1d37c6fd949172.camel@ibm.com>
Date: Fri, 11 Jul 2025 14:16:24 -0400
Cc: "satoru.takeuchi@gmail.com" <satoru.takeuchi@gmail.com>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C6CADD50-D7AD-44FC-8FE4-1687955103C2@dreamsnake.net>
References: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
 <4DFDAA8E-98D2-461D-A5B1-05C482D235A7@dreamsnake.net>
 <bbb5efeac49870dad9783e30df1d37c6fd949172.camel@ibm.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)


> I think I could add here. I am not sure that RBD should support =
blkdiscard.

It definitely supports TRIM operations.

> First of all, "Ceph block devices are thin-provisioned, resizable, and =
store
> data striped over multiple OSDs." =
(https://docs.ceph.com/en/reef/rbd/).

I think I partly wrote that ;)

> So, it means that OSDs could use HDDs, SSDs, or any other type of =
storage device that
> could not support TRIM command.

RBD definitely supports TRIM, which is all the client needs to worry =
about if the intent is to reclaim freed raw capacity.

What Ceph does to the underlying devices shouldn=E2=80=99t matter to the =
client.


>  Also, thin-
> provisioning implies that some logical space could be not allocated =
yet to
> physical space. And if you try to issue the blkdiscard to such space =
what does
> this command mean?

Not sure, I=E2=80=99ve only ever used client-side fstrim for surgical =
trimming.

> So, it's pretty obvious how the blkdiscard command should
> work for SSDs, but it's not clear at all what it means for RBD case.

That=E2=80=99s why I asked what your goal is from running blkdiscard.


> We can treat something as problem or issue if something worked as =
expected
> before, but now it doesn't work. Could you confirm that it worked as =
you
> "expect" before 6.6.95? Otherwise, it's not the issue or bug.

I will have to defer to devs on that.  Myunderstanding is that TRIM =
should not be expected to zero-fill, but I could be mistaken.




