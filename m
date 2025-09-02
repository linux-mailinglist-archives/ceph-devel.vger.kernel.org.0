Return-Path: <ceph-devel+bounces-3504-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42637B40F00
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 23:06:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3DC91B65C1D
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 21:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3074030DD3C;
	Tue,  2 Sep 2025 21:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMyFJoHB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F992E3397;
	Tue,  2 Sep 2025 21:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756847165; cv=none; b=LWLiNYnhaJamr5j3eZgAzWgeIp1tFGb81xiw9CyxuKBB0aNSA2WNALEWUWimHp/qktR63VEyD0jKnfkQFbETXKS7XOOZSF9nQDJunQwa+ZnT3lxaHgtN+p6gMqAXEK76MEGBV1erP0Tfz/QmNmvlQWC7ItPMOTqaA0vL4ryR7fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756847165; c=relaxed/simple;
	bh=F+sNQoiV11l/99944sCCatiPrQr7r6jxss3CEwRTbGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VaoVCAZY3PMLph72OJoU1D+fUYGQxaOIkrXuFbrBp/ztDB3xgx9wXFDFSeA5lYXa3NQle2n9xOEkjzvLetHmsxAfQIFDNNtRA7LL5V3YFvoklkGzrP494u4hts+u2MTpHPH+8PQ09t/ZYC7MOyeyXXTMx7OTwVYLiev6IBG97X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bMyFJoHB; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24c784130e6so8646755ad.3;
        Tue, 02 Sep 2025 14:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756847162; x=1757451962; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qJLfEYkB6UVJumLExVLCIIWdWfypSDCafuwiOw0/T4E=;
        b=bMyFJoHBL+nMyrW2fzV4iLdvkbviOPnd043TI/T0iEGFCFjJYdJvYn59dMNtfMAJVb
         8wsTXJMriMoRRTIKlZcKqioJLNPqoXPStEWDep9ucIW6zt4gCKoOZc34eq+DfzGXYjyu
         Ep79TcZQpfA0uXnEIIhrh8EW4CZJYYiH0axwDgNqR3PHoB5TIpFIpPR872zjhJ1aepBy
         MyKm89xmxNw+RrEhOcib3izJnE/wUIpmBV++5UsVp2furV0BydGY2Qd3c70Y69JZVYS8
         d3N88FZy7dolJdK/sOeSyKHODehSBERiE/lzaM91MViaKheMqc26/sDNeKt8N2O6LqBX
         DRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756847162; x=1757451962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJLfEYkB6UVJumLExVLCIIWdWfypSDCafuwiOw0/T4E=;
        b=sZ3vs2YI3MiCHQQKt6Sn8qSH3JzgtQQu9BsK8Vpz/KtafhYcdK0zvDiO6KlA+SKgT6
         Tit/ectzejCT3mUoyhgm9a0/owOW5b8EIA35EtaU5MMjKRYVy95arkREEtlwQws9K3kF
         Y6uHIYLhNOvZJkd0q7uQoCZgv3U2Pw3+RHFfP0BkIpPJFIqvqkStuo/GPN5HT7SHS/zm
         NbmjjMIeQcUJ6Kb4I1q0dVC3mDGD12XXRwxTeVFtooFDtIypCogta7O9Gg6yJVqxfpx8
         7QTFslhE/pRHF83LJA3lFkjKBWAVSZi4lUl8SAbqcMvVKA8O5v+FKbtW0JuMzwdU9x7x
         onLg==
X-Forwarded-Encrypted: i=1; AJvYcCX0dZAu24hP/8GciUog8nvjUvzEvnhFy3uVE25O7oV4sJbeXkn7N7Qg8YNLKl5Pwxis7q0GgOjOd6mZ@vger.kernel.org, AJvYcCXwQQXA3uhmsDsaSqipJTel6YASC3YOlZu3GH8FH+nq8uPaOXhm/j3PMcANZ+qsNlLxp2nMxGnJEZG9oEdA@vger.kernel.org
X-Gm-Message-State: AOJu0YwKE/x3VpQMsljIauQZVrDG0lSXX4J/etixkrZEAUVLN2pieUMP
	2tRHw0yPE3z5hnArRqZnyV+VPwVZXTsCHGyiWtXAWypgdkdRraok4Rvj
X-Gm-Gg: ASbGnct1yieGWsF9Av4S+2ceLtSx65X2pefg5MAMxOa3pVWrpivjc3VxboL9shfvLwC
	ffvCGBIYLCIk5rj4gShnxK00PVeeXFDWx/vks952Bzx8JyFvlUgx0TuudMAfO441LC4ioySwdxq
	+k62r5WIk1gbGQfRT6K0ZbUuy+qIquvWVG0DHnzwKfn3Y3SEKpr2vKsCiDjBSPYx+nT8CDi5moK
	MHRYxX0AOoGWf9Wg9JgF/E/8318gvxKOhK3v3KA5oMCHzIFws1uEjxn1wsTGEcWqamLb7b1bvhw
	ePv5QgxEbX0KvQhvER2KRQbHGzgTvGiw5EDTJ5xoDRv5qr9j0t5lehgMwhj7za6UPn6kcfTU5/D
	V676bwdKyep4G2tt+H7MWq2ZjSrM8U8cd1SBjYQLlMfg11JQxNLhIIQ8DQVq/
X-Google-Smtp-Source: AGHT+IGh+tV4SjXIbE0trtatefR8wbkxy6wvOIBQ3nR/wzXRrjg9bED0JDhMSe62lWtxxpKydJDbyw==
X-Received: by 2002:a17:902:f707:b0:24b:1d30:5b09 with SMTP id d9443c01a7336-24b1d3076f8mr32649735ad.13.1756847162210;
        Tue, 02 Sep 2025 14:06:02 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24c860066d3sm4002475ad.71.2025.09.02.14.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 14:06:01 -0700 (PDT)
Date: Wed, 3 Sep 2025 05:05:58 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: "409411716@gms.tku.edu.tw" <409411716@gms.tku.edu.tw>,
	Xiubo Li <xiubli@redhat.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: optimize ceph_base64_encode() with block processing
Message-ID: <aLdcNhKrPXxaEUtm@visitorckw-System-Product-Name>
References: <20250830132822.7827-1-409411716@gms.tku.edu.tw>
 <fce1adab2b450097edbcea3ec83420257997ec00.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fce1adab2b450097edbcea3ec83420257997ec00.camel@ibm.com>

On Tue, Sep 02, 2025 at 07:37:22PM +0000, Viacheslav Dubeyko wrote:
> On Sat, 2025-08-30 at 21:28 +0800, Guan-Chun Wu wrote:
> > Previously, ceph_base64_encode() used a bitstream approach, handling one
> > input byte at a time and performing extra bit operations. While correct,
> > this method was suboptimal.
> > 
> 
> Sounds interesting!
> 
> Is ceph_base64_decode() efficient then?
> Do we have something in crypto library of Linux kernel? Maybe we can use
> something efficient enough from there?
> 
Hi Viacheslav,

FYI, we already have base64 encode/decode implementations in
lib/base64.c. As discussed in another thread [1], I think we can put
the optimized version there and have users switch to call the library
functions.

[1]: https://lore.kernel.org/lkml/38753d95-8503-4b72-9590-cb129aa49a41@t-8ch.de/

Hi Guan-Chun,

I was also trying optimizing base64 performance, but I saw your patch
first. Happy to help if you need any assistance!

Regards,
Kuan-Wei

> > This patch processes input in 3-byte blocks, mapping directly to 4 output
> > characters. Remaining 1 or 2 bytes are handled according to standard Base64
> > rules. This reduces computation and improves performance.
> > 
> 
> So, why namely 3-byte blocks? Could you please explain in more details your
> motivation and improved technique in commit message? How exactly your technique
> reduces computation and improves performance?
> 
> > Performance test (5 runs) for ceph_base64_encode():
> > 
> > 64B input:
> > -------------------------------------------------------
> > > Old method | 123 | 115 | 137 | 119 | 109 | avg ~121 ns |
> > -------------------------------------------------------
> > > New method |  84 |  83 |  86 |  85 |  84 | avg ~84 ns  |
> > -------------------------------------------------------
> > 
> > 1KB input:
> > --------------------------------------------------------
> > > Old method | 1217 | 1150 | 1146 | 1149 | 1149 | avg ~1162 ns |
> > --------------------------------------------------------
> > > New method |  776 |  772 |  772 |  774 |  770 | avg ~773 ns  |
> > --------------------------------------------------------
> > 
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> > Tested on Linux 6.8.0-64-generic x86_64
> > with Intel Core i7-10700 @ 2.90GHz
> > 
> 
> I assume that it is still the commit message. So, I think this portion should be
> before Signed-off-by.
> 
> > Test is executed in the form of kernel module.
> 
> > Test script:
> > 
> 
> Is it finally script or kernel module? As far as I can see, it is not complete
> source code. So, I am not sure that everybody will be capable to build and test
> this module.
> 
> What's about to introduce this as Kunit test or self-test that can be used by
> everybody in CephFS kernel client for testing and checking performance? I am
> working on initial set of Kunit tests for CephFS kernel client right now.
> 
> > static int encode_v1(const u8 *src, int srclen, char *dst)
> > {
> > 	u32 ac = 0;
> > 	int bits = 0;
> > 	int i;
> > 	char *cp = dst;
> > 
> > 	for (i = 0; i < srclen; i++) {
> > 		ac = (ac << 8) | src[i];
> > 		bits += 8;
> > 		do {
> > 			bits -= 6;
> > 			*cp++ = base64_table[(ac >> bits) & 0x3f];
> > 		} while (bits >= 6);
> > 	}
> > 	if (bits)
> > 		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> > 	return cp - dst;
> > }
> > 
> > static int encode_v2(const u8 *src, int srclen, char *dst)
> > {
> > 	u32 ac = 0;
> > 	int i = 0;
> > 	char *cp = dst;
> > 
> > 	while (i + 2 < srclen) {
> > 		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8) | (u32)src[i + 2];
> > 		*cp++ = base64_table[(ac >> 18) & 0x3f];
> > 		*cp++ = base64_table[(ac >> 12) & 0x3f];
> > 		*cp++ = base64_table[(ac >> 6) & 0x3f];
> > 		*cp++ = base64_table[ac & 0x3f];
> > 		i += 3;
> > 	}
> > 
> > 	switch (srclen - i) {
> > 	case 2:
> > 		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8);
> > 		*cp++ = base64_table[(ac >> 18) & 0x3f];
> > 		*cp++ = base64_table[(ac >> 12) & 0x3f];
> > 		*cp++ = base64_table[(ac >> 6) & 0x3f];
> > 		break;
> > 	case 1:
> > 		ac = ((u32)src[i] << 16);
> > 		*cp++ = base64_table[(ac >> 18) & 0x3f];
> > 		*cp++ = base64_table[(ac >> 12) & 0x3f];
> > 		break;
> > 	}
> > 	return cp - dst;
> > }
> > 
> > static void run_test(const char *label, const u8 *data, int len)
> > {
> >     char *dst1, *dst2;
> >     int n1, n2;
> >     u64 start, end;
> > 
> >     dst1 = kmalloc(len * 2, GFP_KERNEL);
> >     dst2 = kmalloc(len * 2, GFP_KERNEL);
> > 
> >     if (!dst1 || !dst2) {
> >         pr_err("%s: Failed to allocate dst buffers\n", label);
> >         goto out;
> >     }
> > 
> >     pr_info("[%s] input size = %d bytes\n", label, len);
> > 
> >     start = ktime_get_ns();
> >     n1 = encode_v1(data, len, dst1);
> >     end = ktime_get_ns();
> >     pr_info("[%s] encode_v1 time: %lld ns\n", label, end - start);
> > 
> >     start = ktime_get_ns();
> >     n2 = encode_v2(data, len, dst2);
> >     end = ktime_get_ns();
> >     pr_info("[%s] encode_v2 time: %lld ns\n", label, end - start);
> > 
> >     if (n1 != n2 || memcmp(dst1, dst2, n1) != 0)
> >         pr_err("[%s] Mismatch detected between encode_v1 and encode_v2!\n", label);
> >     else
> >         pr_info("[%s] Outputs are identical.\n", label);
> > 
> > out:
> >     kfree(dst1);
> >     kfree(dst2);
> > }
> > ---
> >  fs/ceph/crypto.c | 33 ++++++++++++++++++++++-----------
> >  1 file changed, 22 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> > index 3b3c4d8d401e..a35570fd8ff5 100644
> > --- a/fs/ceph/crypto.c
> > +++ b/fs/ceph/crypto.c
> > @@ -27,20 +27,31 @@ static const char base64_table[65] =
> >  int ceph_base64_encode(const u8 *src, int srclen, char *dst)
> >  {
> >  	u32 ac = 0;
> > -	int bits = 0;
> > -	int i;
> > +	int i = 0;
> >  	char *cp = dst;
> >  
> > -	for (i = 0; i < srclen; i++) {
> > -		ac = (ac << 8) | src[i];
> > -		bits += 8;
> > -		do {
> > -			bits -= 6;
> > -			*cp++ = base64_table[(ac >> bits) & 0x3f];
> > -		} while (bits >= 6);
> > +	while (i + 2 < srclen) {
> 
> Frankly speaking, I am not completely happy about hardcoded constants. As a
> result, it makes code hard to understand, modify and support. Could you please
> introduce named constants instead of hardcoded numbers?
> 
> 
> > +		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8) | (u32)src[i + 2];
> > +		*cp++ = base64_table[(ac >> 18) & 0x3f];
> > +		*cp++ = base64_table[(ac >> 12) & 0x3f];
> > +		*cp++ = base64_table[(ac >> 6) & 0x3f];
> > +		*cp++ = base64_table[ac & 0x3f];
> > +		i += 3;
> > +	}
> > +
> > +	switch (srclen - i) {
> > +	case 2:
> > +		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8);
> > +		*cp++ = base64_table[(ac >> 18) & 0x3f];
> > +		*cp++ = base64_table[(ac >> 12) & 0x3f];
> > +		*cp++ = base64_table[(ac >> 6) & 0x3f];
> > +		break;
> > +	case 1:
> > +		ac = ((u32)src[i] << 16);
> > +		*cp++ = base64_table[(ac >> 18) & 0x3f];
> > +		*cp++ = base64_table[(ac >> 12) & 0x3f];
> > +		break;
> >  	}
> > -	if (bits)
> > -		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> >  	return cp - dst;
> >  }
> >  
> 
> Let me test your patch and check that it doesn't introduce regression(s).
> 
> Thanks,
> Slava.

