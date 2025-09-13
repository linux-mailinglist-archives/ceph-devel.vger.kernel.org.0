Return-Path: <ceph-devel+bounces-3606-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6918EB56339
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Sep 2025 23:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07988A067CE
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Sep 2025 21:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8D528135B;
	Sat, 13 Sep 2025 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZyVM9Ml9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC88280334
	for <ceph-devel@vger.kernel.org>; Sat, 13 Sep 2025 21:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757798840; cv=none; b=BfI1D29b+bAwHJMaY9/r7E6G8MalQhjl038dVXCiB0987foItT/lZB4JAjkpp+qFB3AtSw9io7UFTfFWFWGvwFo2O3rToNyuwvguclDaAsyvEBefnBU2ev1ohdO3c4ARKDnZ+Y+CV8s2U7LAEqOZ6Ni/kVe5Dy34V2brUZ76ads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757798840; c=relaxed/simple;
	bh=ufmuC/ajygYiJt41KWo5diQtSs90kkBHWQ3weR88km8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PoVRPlcpcBadtm2fMcDC4BpBSTdURAfxoMzBZjtxVhPlswwTDTyqyDOXXN2uwfq7tz5O2s1lgA7gVVXQRzeXsi/FBLvWW0cyrmXPyExkfjgGPNDwnbJojTTBDMk7o/U0wUA3itdFDMoltQ4S4p3I20WK07WzSmNzobh2Btwn7QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZyVM9Ml9; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3e8ea11a325so654389f8f.1
        for <ceph-devel@vger.kernel.org>; Sat, 13 Sep 2025 14:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757798837; x=1758403637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=04qpIN+fZKNNBN7I+FlAUBoFYreC9O4k+On5eLa+qz8=;
        b=ZyVM9Ml9U/B6y3PK+oYcv1qH9jmaqOM0eQfdzZTsdLPxGUl5rR50UpbYYnGv1zHLeU
         foeN1HBMaqpb+GjPbETyt/HlTsMpJs9yrN4OIdp4NErbUP8Q0OSqn2lNIQHfGu2O+8L4
         v6k8KRhqjkN/UOL1E92R88l2ZeDUo0KyGv+xHJIWYPieMz+9dtz2PlYnm11U0acPeMps
         I68hGve/X2jDAajNgQUbF49X3rD7ZeCpGUtXWcYKPJG+hSPqIk8+x3BYjjGkvgyrTwxj
         5xJHi/47LtAOqpSnGU9CvTuW9H3PdRhvcU0MyKRvijbtU7ttzXZqYTe1lG/ibUg8htnG
         7slQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757798837; x=1758403637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=04qpIN+fZKNNBN7I+FlAUBoFYreC9O4k+On5eLa+qz8=;
        b=VSkw9D7AlZ/Y/wGOtcvkww5ADStzzHj3R5WfOliiDOj6nAyxowJqTKbK4qCKohG7E/
         1fbU0YVNh/LoEQjC4dJAlGQxMj6aqwVuDpOn3DwMF62ik0L3EvPFjAtwv/JPl6bE3spF
         NnhfyH6qpFcuzUIToPYjXhmjlfdmCiFhSfUt9xjM8ZPsqByP2G++UkUqOG54kWuCTMiA
         XvnMBfIT+qhTyDhOLk3wY6ms1CsLWx4pz+uBbAOSuPYaKNmeZA3sJbFPHTqx1xGVA+ri
         ytPU570U1j4aO59e60HgiqMPy7KOZTsIyF/0fPCSLPTA1bJpG/2Rh44HNXjkW5rL4PWd
         IEUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVDZAPb3Zmx8J+DIaz8kwQrgYakqxNqLVscwY0VJZJU2s3aDONKXtd+Kk5c3DnXR/0yFLp+WXjD5Fs@vger.kernel.org
X-Gm-Message-State: AOJu0YyJNWr4p2fVQdXo/iErXHQ4zy7+21EsQoW+YWRY8lf9p/dlHQCM
	bLfGKm2r0gQv2GfHLbJgoWhwGkt/qF6d8kRDmG1ugxqnFT59DNZGJ527
X-Gm-Gg: ASbGncuAFpC6xBOT9oPBjG6YeQkop7cTDeD0CMQ5I/ZNJbSo1ixw6W5OAgXExI0lsuA
	xSeyr4rmbWB/c8ZKSlqQHddVLsMmi1Q4pJT79rOupi702zu4iknDaZYhcN+2w+6EwrDTRHvPR8w
	N4zVfdMcz559MD7c+NpAASszQA2dBtgHMo63QSclY9uwsWQ0/G8zYsSkn8ZWayGX0ANnBBQPUVZ
	wApZhrfjL4ptzXQQqLdo7Qgakjn1lmqygQGuEsVZ+a+dNB3wDsCydQfTQ3LX/mdgc/rXbeqfkeG
	xuKHQWwn+URB7rdQm7pWhQq+Y72ZIjzNKu8uDqfgXGQDoMtfW/3Z+H6zeY7UnODlB04W3MKvXk9
	FCbefZpmhY8PNsy2e2todkLmvJxTXuEjlVrKIPPHohz1Ktn9tqe7iUdk1rxVHX9D7Yhs0meY8sS
	XoRL1olw==
X-Google-Smtp-Source: AGHT+IGN6z9+pVmuqZyHNovffXCVFTiBlSaxwVU9Is7CF2e2b52XUbcCYIX0d3TqqhVYSkV6hsC0Cg==
X-Received: by 2002:a05:6000:2307:b0:3e3:e7a0:1fec with SMTP id ffacd0b85a97d-3e7657924f5mr5797120f8f.16.1757798836589;
        Sat, 13 Sep 2025 14:27:16 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e9a066366fsm753048f8f.44.2025.09.13.14.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 14:27:16 -0700 (PDT)
Date: Sat, 13 Sep 2025 22:27:14 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Guan-Chun Wu
 <409411716@gms.tku.edu.tw>, akpm@linux-foundation.org, axboe@kernel.dk,
 ceph-devel@vger.kernel.org, hch@lst.de, home7438072@gmail.com,
 idryomov@gmail.com, jaegeuk@kernel.org, kbusch@kernel.org,
 linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
 xiubli@redhat.com
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better
 performance
Message-ID: <20250913222714.47b9e65b@pumpkin>
In-Reply-To: <aMMYmfVfmkm7Ei+6@visitorckw-System-Product-Name>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
	<20250911073204.574742-1-409411716@gms.tku.edu.tw>
	<20250911181418.GB1376@sol>
	<aMMYmfVfmkm7Ei+6@visitorckw-System-Product-Name>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Sep 2025 02:44:41 +0800
Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> Hi Eric,
> 
> On Thu, Sep 11, 2025 at 11:14:18AM -0700, Eric Biggers wrote:
> > On Thu, Sep 11, 2025 at 03:32:04PM +0800, Guan-Chun Wu wrote:  
> > > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > 
> > > The base64 decoder previously relied on strchr() to locate each
> > > character in the base64 table. In the worst case, this requires
> > > scanning all 64 entries, and even with bitwise tricks or word-sized
> > > comparisons, still needs up to 8 checks.
> > > 
> > > Introduce a small helper function that maps input characters directly
> > > to their position in the base64 table. This reduces the maximum number
> > > of comparisons to 5, improving decoding efficiency while keeping the
> > > logic straightforward.
> > > 
> > > Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> > > over 1000 runs, tested with KUnit):
> > > 
> > > Decode:
> > >  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
> > >  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
> > > 
> > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > ---
> > >  lib/base64.c | 17 ++++++++++++++++-
> > >  1 file changed, 16 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/lib/base64.c b/lib/base64.c
> > > index b736a7a43..9416bded2 100644
> > > --- a/lib/base64.c
> > > +++ b/lib/base64.c
> > > @@ -18,6 +18,21 @@
> > >  static const char base64_table[65] =
> > >  	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> > >  
> > > +static inline const char *find_chr(const char *base64_table, char ch)
> > > +{
> > > +	if ('A' <= ch && ch <= 'Z')
> > > +		return base64_table + ch - 'A';
> > > +	if ('a' <= ch && ch <= 'z')
> > > +		return base64_table + 26 + ch - 'a';
> > > +	if ('0' <= ch && ch <= '9')
> > > +		return base64_table + 26 * 2 + ch - '0';
> > > +	if (ch == base64_table[26 * 2 + 10])
> > > +		return base64_table + 26 * 2 + 10;
> > > +	if (ch == base64_table[26 * 2 + 10 + 1])
> > > +		return base64_table + 26 * 2 + 10 + 1;
> > > +	return NULL;
> > > +}
> > > +
> > >  /**
> > >   * base64_encode() - base64-encode some binary data
> > >   * @src: the binary data to encode
> > > @@ -78,7 +93,7 @@ int base64_decode(const char *src, int srclen, u8 *dst)
> > >  	u8 *bp = dst;
> > >  
> > >  	for (i = 0; i < srclen; i++) {
> > > -		const char *p = strchr(base64_table, src[i]);
> > > +		const char *p = find_chr(base64_table, src[i]);
> > >  
> > >  		if (src[i] == '=') {
> > >  			ac = (ac << 6);  
> > 
> > But this makes the contents of base64_table no longer be used, except
> > for entries 62 and 63.  So this patch doesn't make sense.  Either we
> > should actually use base64_table, or we should remove base64_table and
> > do the mapping entirely in code.
> >   
> For base64_decode(), you're right. After this patch it only uses the last
> two entries of base64_table. However, base64_encode() still makes use of
> the entire table.
> 
> I'm a bit unsure why it would be unacceptable if only one of the two
> functions relies on the full base64 table.

I think the point is that that first 62 entries are fixed, only the last two
change.
Passing the full table might make someone think they can an arbitrary table.
Clearly this isn't true.

Having the full table is convenient for the encoder (although the memory
lookups may be slower than other algorithms).
This might be ok if you could guarantee the compiler would use conditional moves:
	if (val > 26)
		val += 'a' - 'Z' - 1;
	if (val > 52)
		val += '0' - 'z' - 1;
	if (val > 62)
		val = val == 62 ? ch_62 : ch_63;
	else
		val += 'A';

This test code seems to do the decode.
The only conditional is in the path for 62 and 53 (and errors).

int main(int argc, char **argv)
{
        char *cp = argv[1];
        unsigned char ch;
        unsigned int bank, val;
        unsigned int ch_62 = '+', ch_63 = '/';

        if (!cp)
                return 1;
        while ((ch = *cp++)) {
                bank = (ch >> 5) * 4;
                val = ch & 0x1f;
		// Need to subtract 1 or 16, variants using 'conditional move'
		// are probably better - but not all cpu have sane ones.
                val -= ((0xf << 4) >> bank) + 1;
                if (val >= (((10u << 4 | 26u << 8 | 26u << 12) >> bank) & 0x1e)) {
                        if (ch == ch_62)
                                val = 62;
                        else if (ch == ch_63)
                                val = 63;
                        else
                                val = 255;
                } else {
                        val += ((52u << 8 | 0u << 16 | 26u << 24) >> (bank * 2)) & 63;
                }
                printf("%c => %u\n", ch, val);
        }
        return 0;
}

	David

> 
> Regards,
> Kuan-Wei
> 
> 


