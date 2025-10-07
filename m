Return-Path: <ceph-devel+bounces-3786-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE670BC0A0F
	for <lists+ceph-devel@lfdr.de>; Tue, 07 Oct 2025 10:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82B003C59EC
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Oct 2025 08:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69DD2D3EF6;
	Tue,  7 Oct 2025 08:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="pu8FsnGx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6C72D3228
	for <ceph-devel@vger.kernel.org>; Tue,  7 Oct 2025 08:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759825721; cv=none; b=CkYAnFV6JUc9q7BeRxvnO08qMZwa7vP2VFiBlSPssUGVf9wroc+fe32UKgycR9BnIh/KiJCXGuGI50W57cEoeHFNsl1rF5yd4s+Lxw/CGMk3kg+E4KojaP976jq3zlR3NHfCvFpI0oM7d+4pLfpwY/yWmTL+WSoEj1+s+5lut+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759825721; c=relaxed/simple;
	bh=v58jWvQoyfMSBE5jxEjsDbq9G1fKmz755oMlmPtk7LI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXgNcsD3wVnnm7dwNxX9BpNX9ekt1O2x98maJ5HW1fwgot46YTnzvK7+YBngDXNi+sAfDwlrTObWbLK9eFory2/x4xho56EMARwx205z3zU/GKbtaMJ7MDb9e6t5SaDw8Mfnyc/M5d1ezTnK1jY9s18CXoz8XazRazsBVjvmDMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=pu8FsnGx; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2698384978dso42775145ad.0
        for <ceph-devel@vger.kernel.org>; Tue, 07 Oct 2025 01:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1759825717; x=1760430517; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YpZbJ1QMIGXsJO95EeDbekSvm5I9yv7BUeFhQgDIPcg=;
        b=pu8FsnGxpXLCQdPkpKSuW3EDB+yZyDkTSpuwjjx5eh5lX+zVsaEqGGOb5fuUrzYqau
         YZfWst3hs+MbeGMi8QYqFnVbYKlhjcuZawDV1O3TGkYhSgK/2PjpI+54mJQdqpxhF42D
         H3jM3kww/eDAbG+SyxltpKVP8hL5XO24ywItZACi3TUmedJOF0EoaTfOhUSof0/nXOC3
         bZ6Dorpk+b1gYVaL8TYL/tV7wQWNLNZ+h6NPLSfNw/4kUibyIwGH8OBxr/Hw3UN1/o4u
         vIycS/WB9kblyuv0fA//Ey86HoSTiY4zweEWjes2v0394/MF4Ri7Sey9tM4YRKPUrCLe
         yFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759825717; x=1760430517;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YpZbJ1QMIGXsJO95EeDbekSvm5I9yv7BUeFhQgDIPcg=;
        b=gQT0cRVgYDE2Qb2HuXHWKXFT6eofWs9gA2JehTaL12ulXthD0XarrDrRm/MpTwNe66
         osT4hgsFI9k8+QWdRTdBqlz/Eho52RTNxHDNgE1JjX1vC7L43tLaQO7EYXOj+iDgack2
         rL5rcqVO0Y5fW0anFjHLUlYb8QiBhU085YwTfzDVSIwdEcWq2XrfMYP9+Vxq9XyjvCD9
         jVADuvMvmrckS5ml15iLfUaK2HLC6HGzw9JzHW+knFvLubE9qY5E+8sQy00HnAyBuaff
         Ntev4gspEUQYNU7OfPCDTNX3yVkH96H37jTD8t/TQn6vMJ5xtbJs2Bhc3TAVwrCj/tUP
         tPfg==
X-Forwarded-Encrypted: i=1; AJvYcCUaDitFvpVmPMiRmkVEFJK4WiDNM2n3kmVg1CitvxNhoeQX1btf3yQAFpHCl1dTXPUb5SaInCdfWIGY@vger.kernel.org
X-Gm-Message-State: AOJu0YwXmCM1HLssUzISQZuNv78ssYubQxQNDnP3DxIBwQ2Ypr4TYbDq
	/fKIw9OEnIbCThGt7mMr9GJxzsx7IJ/gaj2eEO52AZYND/M45irGPr8lrc3IVxA4B10=
X-Gm-Gg: ASbGncvir1ZFKYGrNjQzeqNs6IMlmrPsKcimq6jVbrCq6OR/6KPM4bZgyO67bzH4cM/
	I1MMcBQvK7+mtGDLJ4pNiN32OezJhec5STKcGA3hq5v5QaSNRRMOmz+ITAoonlgNWCkJjDwc/5y
	VhDYe+NWtZsUYdJaIYgNozEc1HqY8S9Q8MhucsmuTKAyEGUyYpNwU1uVpt9taZmmBpHZP2+SEQP
	8W3Uc7X4OxnFfTf99dnv1QATfdJC3GFAMm5OnmGTLM7vz9V+/Bh+pTeXPQnikDK7vuOrTStKyFf
	5ZtvyXOLWg5kGVCdqlWlZh5N9suYiN7nLzc/I5dNAme8XhJfD8m7M9tFJcctK9br6vCNXra+B9D
	9c7EuWzmCfsN/7DS4xQRv3DgUWfFff+EVAqjL+UxNhD3xjWWGHGIujwsIxzq6OfR8LZ6m
X-Google-Smtp-Source: AGHT+IEUcHDwSc5n5do+7fhgZx/8hDw0+PJKH3ejonSOLpIgKdjmmy9QWd5reRU+rDGGGOObBSG71w==
X-Received: by 2002:a17:902:e785:b0:24c:cc32:788b with SMTP id d9443c01a7336-28e9a5462aemr193596415ad.3.1759825717003;
        Tue, 07 Oct 2025 01:28:37 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:5196:9a8f:bb54:f0db])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1b8796sm156615475ad.77.2025.10.07.01.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 01:28:36 -0700 (PDT)
Date: Tue, 7 Oct 2025 16:28:32 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: David Laight <david.laight.linux@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	akpm@linux-foundation.org, axboe@kernel.dk,
	ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
	kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
Message-ID: <aOTPMGQbUBfgdX4u@wu-Pro-E500-G6-WS720T>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
 <20250926065556.14250-1-409411716@gms.tku.edu.tw>
 <CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
 <aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
 <CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
 <20251005181803.0ba6aee4@pumpkin>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251005181803.0ba6aee4@pumpkin>

On Sun, Oct 05, 2025 at 06:18:03PM +0100, David Laight wrote:
> On Wed, 1 Oct 2025 09:20:27 -0700
> Caleb Sander Mateos <csander@purestorage.com> wrote:
> 
> > On Wed, Oct 1, 2025 at 3:18 AM Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> > >
> > > On Fri, Sep 26, 2025 at 04:33:12PM -0700, Caleb Sander Mateos wrote:  
> > > > On Thu, Sep 25, 2025 at 11:59 PM Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:  
> > > > >
> > > > > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > > >
> > > > > Replace the use of strchr() in base64_decode() with precomputed reverse
> > > > > lookup tables for each variant. This avoids repeated string scans and
> > > > > improves performance. Use -1 in the tables to mark invalid characters.
> > > > >
> > > > > Decode:
> > > > >   64B   ~1530ns  ->  ~75ns    (~20.4x)
> > > > >   1KB  ~27726ns  -> ~1165ns   (~23.8x)
> > > > >
> > > > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > > > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > > ---
> > > > >  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++----
> > > > >  1 file changed, 61 insertions(+), 5 deletions(-)
> > > > >
> > > > > diff --git a/lib/base64.c b/lib/base64.c
> > > > > index 1af557785..b20fdf168 100644
> > > > > --- a/lib/base64.c
> > > > > +++ b/lib/base64.c
> > > > > @@ -21,6 +21,63 @@ static const char base64_tables[][65] = {
> > > > >         [BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
> > > > >  };
> > > > >
> > > > > +static const s8 base64_rev_tables[][256] = {
> > > > > +       [BASE64_STD] = {
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,  -1,  63,
> > > > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > > > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > > > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +       },
> > > > > +       [BASE64_URLSAFE] = {
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,
> > > > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > > > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  63,
> > > > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > > > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +       },
> > > > > +       [BASE64_IMAP] = {
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  63,  -1,  -1,  -1,
> > > > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > > > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > > > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > +       },  
> > > >
> > > > Do we actually need 3 separate lookup tables? It looks like all 3
> > > > variants agree on the value of any characters they have in common. So
> > > > we could combine them into a single lookup table that would work for a
> > > > valid base64 string of any variant. The only downside I can see is
> > > > that base64 strings which are invalid in some variants might no longer
> > > > be rejected by base64_decode().
> > > >  
> > >
> > > In addition to the approach David mentioned, maybe we can use a common
> > > lookup table for A–Z, a–z, and 0–9, and then handle the variant-specific
> > > symbols with a switch.
> 
> It is certainly possible to generate the initialiser from a #define to
> avoid all the replicated source.
> 
> > >
> > > For example:
> > >
> > > static const s8 base64_rev_common[256] = {
> > >     [0 ... 255] = -1,
> > >     ['A'] = 0, ['B'] = 1, /* ... */, ['Z'] = 25,
> 
> If you assume ASCII (I doubt Linux runs on any EBCDIC systems) you
> can assume the characters are sequential and miss ['B'] = etc to
> reduce the the line lengths.
> (Even EBCDIC has A-I J-R S-Z and 0-9 as adjacent values)
> 
> > >     ['a'] = 26, /* ... */, ['z'] = 51,
> > >     ['0'] = 52, /* ... */, ['9'] = 61,
> > > };
> > >
> > > static inline int base64_rev_lookup(u8 c, enum base64_variant variant) {
> > >     s8 v = base64_rev_common[c];
> > >     if (v != -1)
> > >         return v;
> > >
> > >     switch (variant) {
> > >     case BASE64_STD:
> > >         if (c == '+') return 62;
> > >         if (c == '/') return 63;
> > >         break;
> > >     case BASE64_IMAP:
> > >         if (c == '+') return 62;
> > >         if (c == ',') return 63;
> > >         break;
> > >     case BASE64_URLSAFE:
> > >         if (c == '-') return 62;
> > >         if (c == '_') return 63;
> > >         break;
> > >     }
> > >     return -1;
> > > }
> > >
> > > What do you think?  
> > 
> > That adds several branches in the hot loop, at least 2 of which are
> > unpredictable for valid base64 input of a given variant (v != -1 as
> > well as the first c check in the applicable switch case).
> 
> I'd certainly pass in the character values for 62 and 63 so they are
> determined well outside the inner loop.
> Possibly even going as far as #define BASE64_STD ('+' << 8 | '/').
> 
> > That seems like it would hurt performance, no?
> > I think having 3 separate tables
> > would be preferable to making the hot loop more branchy.
> 
> Depends how common you think 62 and 63 are...
> I guess 63 comes from 0xff bytes - so might be quite common.
> 
> One thing I think you've missed is that the decode converts 4 characters
> into 24 bits - which then need carefully writing into the output buffer.
> There is no need to check whether each character is valid.
> After:
> 	val_24 = t[b[0]] | t[b[1]] << 6 | t[b[2]] << 12 | t[b[3]] << 18;
> val_24 will be negative iff one of b[0..3] is invalid.
> So you only need to check every 4 input characters, not for every one.
> That does require separate tables.
> (Or have a decoder that always maps "+-" to 62 and "/,_" to 63.)
> 
> 	David
>

Thanks for the feedback.
For the next revision, we’ll use a single lookup table that maps both +
and - to 62, and /, _, and , to 63.
Does this approach sound good to everyone?

Best regards,
Guan-Chun

> > 
> > Best,
> > Caleb
> > 
> 

