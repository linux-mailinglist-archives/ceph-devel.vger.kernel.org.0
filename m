Return-Path: <ceph-devel+bounces-439-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E711781D632
	for <lists+ceph-devel@lfdr.de>; Sat, 23 Dec 2023 20:15:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0006282E16
	for <lists+ceph-devel@lfdr.de>; Sat, 23 Dec 2023 19:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4D014AB2;
	Sat, 23 Dec 2023 19:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dgqiln0u"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B99B14F85
	for <ceph-devel@vger.kernel.org>; Sat, 23 Dec 2023 19:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40c31f18274so36110255e9.0
        for <ceph-devel@vger.kernel.org>; Sat, 23 Dec 2023 11:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1703358890; x=1703963690; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vmydVtrXfV1+PhmHNSQyFxq8qaU40/ai4YL8AqJQUW0=;
        b=dgqiln0uYCmLOaC24L4uwo2HIik9QJcpUJ1c3nqDrADezlkMmJmCvvXWzRepmboZXj
         C+wx1j/bfzHNLG3//mYXkANPC8xQ3wy5PTz8AmD/JqU46nACO66vWYsqOkcDPYo+ydG9
         KnQjSoHWnitwrEPURAZaR/z2MVm69pPMNEE6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703358890; x=1703963690;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vmydVtrXfV1+PhmHNSQyFxq8qaU40/ai4YL8AqJQUW0=;
        b=MLZNsrj0LSYAa5wJoEYsM2DKRoPbbw0rXH8r9w6fiPJagmGXyP64eQNoIwCb6Q4ijD
         E/ONs/soC5w+w7BO9EUFi0cGp5neQEmObj+hjc/EddJq+5FRms1VKaWpT+27Aj6DQrZp
         joOtspJEAavq2Mr0QG3NLneIP6Q5Mt+8+8zaLjw49ZjsDZ3Z0aUBnZbtFaDuPe8vOUyG
         EfeYK5Q6g3egxHDGAS3dFtwh/+0oDo2H37Q8ms3hzLeeIDUZa2h6ORTNXtN89Wz9bnlv
         QkNn4eXFuzp0b62twUNCwVimGeibROuBNKrK0J2BVf4dqss87h2wVlEKamfPbu7Q2uIi
         Xzug==
X-Gm-Message-State: AOJu0YzPsnEllVaXJzrXirxmpmZNUGe4vR+OFjxFmiRa5V8VW+F9+hc+
	s6vGF0wL1qvH/SISpejzigYwmicbWSz0LiwZMG83hMXM6e7RVQ==
X-Google-Smtp-Source: AGHT+IHkTvVAXxcGtNPy1cT/sOe5z/cU4iZHtJQsXrEq+lv/mdhfMgLm7dyiJhptbipL00i4EnDElg==
X-Received: by 2002:a05:600c:310d:b0:40c:1e66:4dca with SMTP id g13-20020a05600c310d00b0040c1e664dcamr1638930wmo.175.1703358890239;
        Sat, 23 Dec 2023 11:14:50 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id v11-20020a17090610cb00b00a26c2f99cd0sm1606679ejv.204.2023.12.23.11.14.49
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Dec 2023 11:14:50 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a233a60f8feso299800566b.0
        for <ceph-devel@vger.kernel.org>; Sat, 23 Dec 2023 11:14:49 -0800 (PST)
X-Received: by 2002:a17:906:73d5:b0:a23:3bf5:bc73 with SMTP id
 n21-20020a17090673d500b00a233bf5bc73mr1443998ejl.58.1703358889639; Sat, 23
 Dec 2023 11:14:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1843374.1703172614@warthog.procyon.org.uk> <20231223172858.GI201037@kernel.org>
In-Reply-To: <20231223172858.GI201037@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 23 Dec 2023 11:14:32 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgJz36ZE66_8gXjP_TofkkugXBZEpTr_Dtc_JANsH1SEw@mail.gmail.com>
Message-ID: <CAHk-=wgJz36ZE66_8gXjP_TofkkugXBZEpTr_Dtc_JANsH1SEw@mail.gmail.com>
Subject: Re: [GIT PULL] afs, dns: Fix dynamic root interaction with negative DNS
To: Simon Horman <horms@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Markus Suvanto <markus.suvanto@gmail.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Wang Lei <wang840925@gmail.com>, 
	Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	linux-afs@lists.infradead.org, keyrings@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Edward Adam Davis <eadavis@qq.com>
Content-Type: multipart/mixed; boundary="0000000000008aede3060d322575"

--0000000000008aede3060d322575
Content-Type: text/plain; charset="UTF-8"

On Sat, 23 Dec 2023 at 09:29, Simon Horman <horms@kernel.org> wrote:
>
>
>         if (data[0] == 0) {
>                 /* It may be a server list. */
> -               if (datalen <= sizeof(*bin))
> +               if (datalen <= sizeof(*v1))
>                         return -EINVAL;
>
>                 bin = (const struct dns_payload_header *)data;

Ugh, I hate how it checks the size of a *different* structure than the
one it then assigns the pointer to.

So I get the feeling that we should get rid of 'bin' entirely, and
just use the 'v1' pointer, since it literally checks that that is what
it is, and then the size check matches the thing we're casting things
to.

So then "bin->xyz" becomes "v1->hdr.xyz".

Yes, the patch becomes a bit bigger, but I think the end result is a
whole lot more obvious and maintainable.

I'd also move the remaining 'v1' variable declaration to the inner
context where it's actually used.

IOW, I personally would be much happier with a patch like the attached, but I

 (a) don't want to take credit for this, since my change is purely syntactic

 (b) have not tested this patch apart from checking that it compiles
in at least one config

so honestly, I'd love to see this patch come back to me with sign-offs
and tested-bys by the actual people who noticed this.

Hmm?

                 Linus

--0000000000008aede3060d322575
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_lqifv8pp0>
X-Attachment-Id: f_lqifv8pp0

IG5ldC9kbnNfcmVzb2x2ZXIvZG5zX2tleS5jIHwgMTkgKysrKysrKysrLS0tLS0tLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvbmV0L2Ruc19yZXNvbHZlci9kbnNfa2V5LmMgYi9uZXQvZG5zX3Jlc29sdmVyL2Ruc19rZXku
YwppbmRleCAyYTZkMzYzNzYzYTIuLmYxOGNhMDJhYTk1YSAxMDA2NDQKLS0tIGEvbmV0L2Ruc19y
ZXNvbHZlci9kbnNfa2V5LmMKKysrIGIvbmV0L2Ruc19yZXNvbHZlci9kbnNfa2V5LmMKQEAgLTkx
LDggKzkxLDYgQEAgY29uc3Qgc3RydWN0IGNyZWQgKmRuc19yZXNvbHZlcl9jYWNoZTsKIHN0YXRp
YyBpbnQKIGRuc19yZXNvbHZlcl9wcmVwYXJzZShzdHJ1Y3Qga2V5X3ByZXBhcnNlZF9wYXlsb2Fk
ICpwcmVwKQogewotCWNvbnN0IHN0cnVjdCBkbnNfc2VydmVyX2xpc3RfdjFfaGVhZGVyICp2MTsK
LQljb25zdCBzdHJ1Y3QgZG5zX3BheWxvYWRfaGVhZGVyICpiaW47CiAJc3RydWN0IHVzZXJfa2V5
X3BheWxvYWQgKnVwYXlsb2FkOwogCXVuc2lnbmVkIGxvbmcgZGVycm5vOwogCWludCByZXQ7CkBA
IC0xMDMsMjcgKzEwMSwyOCBAQCBkbnNfcmVzb2x2ZXJfcHJlcGFyc2Uoc3RydWN0IGtleV9wcmVw
YXJzZWRfcGF5bG9hZCAqcHJlcCkKIAkJcmV0dXJuIC1FSU5WQUw7CiAKIAlpZiAoZGF0YVswXSA9
PSAwKSB7CisJCWNvbnN0IHN0cnVjdCBkbnNfc2VydmVyX2xpc3RfdjFfaGVhZGVyICp2MTsKKwog
CQkvKiBJdCBtYXkgYmUgYSBzZXJ2ZXIgbGlzdC4gKi8KLQkJaWYgKGRhdGFsZW4gPD0gc2l6ZW9m
KCpiaW4pKQorCQlpZiAoZGF0YWxlbiA8PSBzaXplb2YoKnYxKSkKIAkJCXJldHVybiAtRUlOVkFM
OwogCi0JCWJpbiA9IChjb25zdCBzdHJ1Y3QgZG5zX3BheWxvYWRfaGVhZGVyICopZGF0YTsKLQkJ
a2VudGVyKCJbJXUsJXVdLCV1IiwgYmluLT5jb250ZW50LCBiaW4tPnZlcnNpb24sIGRhdGFsZW4p
OwotCQlpZiAoYmluLT5jb250ZW50ICE9IEROU19QQVlMT0FEX0lTX1NFUlZFUl9MSVNUKSB7CisJ
CXYxID0gKGNvbnN0IHN0cnVjdCBkbnNfc2VydmVyX2xpc3RfdjFfaGVhZGVyICopZGF0YTsKKwkJ
a2VudGVyKCJbJXUsJXVdLCV1IiwgdjEtPmhkci5jb250ZW50LCB2MS0+aGRyLnZlcnNpb24sIGRh
dGFsZW4pOworCQlpZiAodjEtPmhkci5jb250ZW50ICE9IEROU19QQVlMT0FEX0lTX1NFUlZFUl9M
SVNUKSB7CiAJCQlwcl93YXJuX3JhdGVsaW1pdGVkKAogCQkJCSJkbnNfcmVzb2x2ZXI6IFVuc3Vw
cG9ydGVkIGNvbnRlbnQgdHlwZSAoJXUpXG4iLAotCQkJCWJpbi0+Y29udGVudCk7CisJCQkJdjEt
Pmhkci5jb250ZW50KTsKIAkJCXJldHVybiAtRUlOVkFMOwogCQl9CiAKLQkJaWYgKGJpbi0+dmVy
c2lvbiAhPSAxKSB7CisJCWlmICh2MS0+aGRyLnZlcnNpb24gIT0gMSkgewogCQkJcHJfd2Fybl9y
YXRlbGltaXRlZCgKIAkJCQkiZG5zX3Jlc29sdmVyOiBVbnN1cHBvcnRlZCBzZXJ2ZXIgbGlzdCB2
ZXJzaW9uICgldSlcbiIsCi0JCQkJYmluLT52ZXJzaW9uKTsKKwkJCQl2MS0+aGRyLnZlcnNpb24p
OwogCQkJcmV0dXJuIC1FSU5WQUw7CiAJCX0KIAotCQl2MSA9IChjb25zdCBzdHJ1Y3QgZG5zX3Nl
cnZlcl9saXN0X3YxX2hlYWRlciAqKWJpbjsKIAkJaWYgKCh2MS0+c3RhdHVzICE9IEROU19MT09L
VVBfR09PRCAmJgogCQkgICAgIHYxLT5zdGF0dXMgIT0gRE5TX0xPT0tVUF9HT09EX1dJVEhfQkFE
KSkgewogCQkJaWYgKHByZXAtPmV4cGlyeSA9PSBUSU1FNjRfTUFYKQo=
--0000000000008aede3060d322575--

