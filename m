Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30B05908B1
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Aug 2022 00:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbiHKWXF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Aug 2022 18:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHKWXA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 11 Aug 2022 18:23:00 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007B298D35
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 15:22:59 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a7so35910608ejp.2
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 15:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KsXfDpsnVQseda5Cb9wrMuyheSum/QLurm0boPOtabg=;
        b=Vp4dIwe+h6J4VNgbqF8TkHeZtIkW/LqXfVLkoCaEAJpjkFf6k4OtqgQyFwEq/7r6Pa
         AoZaJmmTKCPx93aAIiaAT4WcQtLEMS28t4ettuGfokGi6wc8E62KOqaKLkouMdPv5yId
         DBGGC6qyUU6I0MoYBNjtaTcpwbuzWkmg3hUIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KsXfDpsnVQseda5Cb9wrMuyheSum/QLurm0boPOtabg=;
        b=2a/6WpbVNVcwgGnggIgGAOJfcsuZWCvIm1w9YEGefkQlinaVyp9luIKNcQLCW6gC+F
         1jmc3x8F/Sv4YHf1eJBOcrm5zrurnzv8SSfakJ9MV/7kUtuxD77Igw9H841DApotH6jt
         s8ckxgiPaMRxGgCVWkyiLcfPGOMEifbVG64IPteLcTj7sW6pgvc8VakQOPTsIQtCRPUJ
         G+1VRRZzlTHjd5ppjkAeu9Qgl8lzh6w8T28wFscjfpKcIx1xyJudA7ZYG9cp7UmJvl74
         Nq24seLRiX7tnD7de7IZYq2obiGi9Hi2A/jJBYsFU9sMrVti5Q644qSlGacffMsPGEDF
         oFPA==
X-Gm-Message-State: ACgBeo20rKk9n6WukzKS6H1sNYx/CboN88+H60PoFZTN5podUwcqEr9N
        GVMoZYHlBmdywbKm7OUx2K+EOLlObNbUTNNb
X-Google-Smtp-Source: AA6agR7ddGWJq01hgCvjTOHUFIDtfl7St/ofuTyv48aBlxeK7PEjvFzMlZu6pifV48Tq/kc1htm1gg==
X-Received: by 2002:a17:907:3e28:b0:731:7ee0:add5 with SMTP id hp40-20020a1709073e2800b007317ee0add5mr728479ejc.215.1660256578323;
        Thu, 11 Aug 2022 15:22:58 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id jj23-20020a170907985700b0073151ce7726sm128378ejc.100.2022.08.11.15.22.55
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 15:22:56 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id q30so22763414wra.11
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 15:22:55 -0700 (PDT)
X-Received: by 2002:a05:6000:1888:b0:222:ca41:dc26 with SMTP id
 a8-20020a056000188800b00222ca41dc26mr465484wri.442.1660256575053; Thu, 11 Aug
 2022 15:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220811152446.281723-1-idryomov@gmail.com> <CAHk-=wifgq59uru6xDB=nY-1p6aQ-1YB8nVhW7T-N2ctK3m1gw@mail.gmail.com>
 <CAOi1vP9BSi-65of-8D0BA1_DC0eVD_TQcWkhrGJwaXw_skhHFQ@mail.gmail.com>
 <5d0b0367a5e28ec5b1f3b995c7792ff9a5cbcbd4.camel@kernel.org>
 <YvVzHQ5DVaPAvw26@ZenIV> <72a93a2c8910c3615bba7c093c66c18b1a6a2696.camel@kernel.org>
 <YvV2zfT0XbgwHGe/@ZenIV> <CAHk-=wgYnAPiGsh7H4BS_E1aMM46PdSGg8YqFhi2SpGw+Ac_PQ@mail.gmail.com>
 <YvV86p5DjBLjjXHo@ZenIV>
In-Reply-To: <YvV86p5DjBLjjXHo@ZenIV>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Aug 2022 15:22:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjCa=Xf=pA2Z844WnwEeYgy9OPoB2kWphvg7PVn3ohScw@mail.gmail.com>
Message-ID: <CAHk-=wjCa=Xf=pA2Z844WnwEeYgy9OPoB2kWphvg7PVn3ohScw@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 5.20-rc1
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: multipart/mixed; boundary="00000000000064959705e5fe9bf0"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--00000000000064959705e5fe9bf0
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 11, 2022 at 3:04 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, I wonder if we should do
>         if (READ_ONCE(dentry->d_parent) != parent)
>                 continue;
> before grabbing ->d_lock (and repeat the check after grabbing it,

It kind of makes sense. We already do that d_name.hash check outside
of the lock, so we already have that "we might race with a rename"
situation.

That said, I do think __d_lookup_rcu() is the more important of the two.

Here's a recreation of that patch I mentioned where the OP_COMPARE is
moved out of the loop. Just for fun, look at how much better the code
generation is for the common case when you don't have the call messing
up the clobbered registers etc.

Entirely untested, and I might have messed something up, but I suspect
this is a much bigger deal than whether d_same_name() is inlined or
not in the non-RCU path.

              Linus

--00000000000064959705e5fe9bf0
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_l6plvdp70>
X-Attachment-Id: f_l6plvdp70

IGZzL2RjYWNoZS5jIHwgNzIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQ5IGluc2VydGlvbnMoKyks
IDIzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2RjYWNoZS5jIGIvZnMvZGNhY2hlLmMK
aW5kZXggYzVkYzMyYTU5Yzc2Li5iYjBjNGQwMDM4ZGIgMTAwNjQ0Ci0tLSBhL2ZzL2RjYWNoZS5j
CisrKyBiL2ZzL2RjYWNoZS5jCkBAIC0yMjcwLDYgKzIyNzAsNDggQEAgYm9vbCBkX3NhbWVfbmFt
ZShjb25zdCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIGNvbnN0IHN0cnVjdCBkZW50cnkgKnBhcmVu
dCwKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKGRfc2FtZV9uYW1lKTsKIAorLyoKKyAqIFRoaXMgaXMg
X19kX2xvb2t1cF9yY3UoKSB3aGVuIHRoZSBwYXJlbnQgZGVudHJ5IGhhcworICogRENBQ0hFX09Q
X0NPTVBBUkUsIHdoaWNoIG1ha2VzIHRoaW5ncyBtdWNoIG5hc3RpZXIuCisgKi8KK3N0YXRpYyBu
b2lubGluZSBzdHJ1Y3QgZGVudHJ5ICpfX2RfbG9va3VwX3JjdV9vcF9jb21wYXJlKAorCWNvbnN0
IHN0cnVjdCBkZW50cnkgKnBhcmVudCwKKwljb25zdCBzdHJ1Y3QgcXN0ciAqbmFtZSwKKwl1bnNp
Z25lZCAqc2VxcCkKK3sKKwl1NjQgaGFzaGxlbiA9IG5hbWUtPmhhc2hfbGVuOworCXN0cnVjdCBo
bGlzdF9ibF9oZWFkICpiID0gZF9oYXNoKGhhc2hsZW5faGFzaChoYXNobGVuKSk7CisJc3RydWN0
IGhsaXN0X2JsX25vZGUgKm5vZGU7CisJc3RydWN0IGRlbnRyeSAqZGVudHJ5OworCisJaGxpc3Rf
YmxfZm9yX2VhY2hfZW50cnlfcmN1KGRlbnRyeSwgbm9kZSwgYiwgZF9oYXNoKSB7CisJCWludCB0
bGVuOworCQljb25zdCBjaGFyICp0bmFtZTsKKwkJdW5zaWduZWQgc2VxOworCitzZXFyZXRyeToK
KwkJc2VxID0gcmF3X3NlcWNvdW50X2JlZ2luKCZkZW50cnktPmRfc2VxKTsKKwkJaWYgKGRlbnRy
eS0+ZF9wYXJlbnQgIT0gcGFyZW50KQorCQkJY29udGludWU7CisJCWlmIChkX3VuaGFzaGVkKGRl
bnRyeSkpCisJCQljb250aW51ZTsKKwkJaWYgKGRlbnRyeS0+ZF9uYW1lLmhhc2ggIT0gaGFzaGxl
bl9oYXNoKGhhc2hsZW4pKQorCQkJY29udGludWU7CisJCXRsZW4gPSBkZW50cnktPmRfbmFtZS5s
ZW47CisJCXRuYW1lID0gZGVudHJ5LT5kX25hbWUubmFtZTsKKwkJLyogd2Ugd2FudCBhIGNvbnNp
c3RlbnQgKG5hbWUsbGVuKSBwYWlyICovCisJCWlmIChyZWFkX3NlcWNvdW50X3JldHJ5KCZkZW50
cnktPmRfc2VxLCBzZXEpKSB7CisJCQljcHVfcmVsYXgoKTsKKwkJCWdvdG8gc2VxcmV0cnk7CisJ
CX0KKwkJaWYgKHBhcmVudC0+ZF9vcC0+ZF9jb21wYXJlKGRlbnRyeSwgdGxlbiwgdG5hbWUsIG5h
bWUpICE9IDApCisJCQljb250aW51ZTsKKwkJKnNlcXAgPSBzZXE7CisJCXJldHVybiBkZW50cnk7
CisJfQorCXJldHVybiBOVUxMOworfQorCiAvKioKICAqIF9fZF9sb29rdXBfcmN1IC0gc2VhcmNo
IGZvciBhIGRlbnRyeSAocmFjeSwgc3RvcmUtZnJlZSkKICAqIEBwYXJlbnQ6IHBhcmVudCBkZW50
cnkKQEAgLTIzMTYsNiArMjM1OCw5IEBAIHN0cnVjdCBkZW50cnkgKl9fZF9sb29rdXBfcmN1KGNv
bnN0IHN0cnVjdCBkZW50cnkgKnBhcmVudCwKIAkgKiBLZWVwIHRoZSB0d28gZnVuY3Rpb25zIGlu
IHN5bmMuCiAJICovCiAKKwlpZiAodW5saWtlbHkocGFyZW50LT5kX2ZsYWdzICYgRENBQ0hFX09Q
X0NPTVBBUkUpKQorCQlyZXR1cm4gX19kX2xvb2t1cF9yY3Vfb3BfY29tcGFyZShwYXJlbnQsIG5h
bWUsIHNlcXApOworCiAJLyoKIAkgKiBUaGUgaGFzaCBsaXN0IGlzIHByb3RlY3RlZCB1c2luZyBS
Q1UuCiAJICoKQEAgLTIzMzIsNyArMjM3Nyw2IEBAIHN0cnVjdCBkZW50cnkgKl9fZF9sb29rdXBf
cmN1KGNvbnN0IHN0cnVjdCBkZW50cnkgKnBhcmVudCwKIAlobGlzdF9ibF9mb3JfZWFjaF9lbnRy
eV9yY3UoZGVudHJ5LCBub2RlLCBiLCBkX2hhc2gpIHsKIAkJdW5zaWduZWQgc2VxOwogCi1zZXFy
ZXRyeToKIAkJLyoKIAkJICogVGhlIGRlbnRyeSBzZXF1ZW5jZSBjb3VudCBwcm90ZWN0cyB1cyBm
cm9tIGNvbmN1cnJlbnQKIAkJICogcmVuYW1lcywgYW5kIHRodXMgcHJvdGVjdHMgcGFyZW50IGFu
ZCBuYW1lIGZpZWxkcy4KQEAgLTIzNTUsMjggKzIzOTksMTAgQEAgc3RydWN0IGRlbnRyeSAqX19k
X2xvb2t1cF9yY3UoY29uc3Qgc3RydWN0IGRlbnRyeSAqcGFyZW50LAogCQkJY29udGludWU7CiAJ
CWlmIChkX3VuaGFzaGVkKGRlbnRyeSkpCiAJCQljb250aW51ZTsKLQotCQlpZiAodW5saWtlbHko
cGFyZW50LT5kX2ZsYWdzICYgRENBQ0hFX09QX0NPTVBBUkUpKSB7Ci0JCQlpbnQgdGxlbjsKLQkJ
CWNvbnN0IGNoYXIgKnRuYW1lOwotCQkJaWYgKGRlbnRyeS0+ZF9uYW1lLmhhc2ggIT0gaGFzaGxl
bl9oYXNoKGhhc2hsZW4pKQotCQkJCWNvbnRpbnVlOwotCQkJdGxlbiA9IGRlbnRyeS0+ZF9uYW1l
LmxlbjsKLQkJCXRuYW1lID0gZGVudHJ5LT5kX25hbWUubmFtZTsKLQkJCS8qIHdlIHdhbnQgYSBj
b25zaXN0ZW50IChuYW1lLGxlbikgcGFpciAqLwotCQkJaWYgKHJlYWRfc2VxY291bnRfcmV0cnko
JmRlbnRyeS0+ZF9zZXEsIHNlcSkpIHsKLQkJCQljcHVfcmVsYXgoKTsKLQkJCQlnb3RvIHNlcXJl
dHJ5OwotCQkJfQotCQkJaWYgKHBhcmVudC0+ZF9vcC0+ZF9jb21wYXJlKGRlbnRyeSwKLQkJCQkJ
CSAgICB0bGVuLCB0bmFtZSwgbmFtZSkgIT0gMCkKLQkJCQljb250aW51ZTsKLQkJfSBlbHNlIHsK
LQkJCWlmIChkZW50cnktPmRfbmFtZS5oYXNoX2xlbiAhPSBoYXNobGVuKQotCQkJCWNvbnRpbnVl
OwotCQkJaWYgKGRlbnRyeV9jbXAoZGVudHJ5LCBzdHIsIGhhc2hsZW5fbGVuKGhhc2hsZW4pKSAh
PSAwKQotCQkJCWNvbnRpbnVlOwotCQl9CisJCWlmIChkZW50cnktPmRfbmFtZS5oYXNoX2xlbiAh
PSBoYXNobGVuKQorCQkJY29udGludWU7CisJCWlmIChkZW50cnlfY21wKGRlbnRyeSwgc3RyLCBo
YXNobGVuX2xlbihoYXNobGVuKSkgIT0gMCkKKwkJCWNvbnRpbnVlOwogCQkqc2VxcCA9IHNlcTsK
IAkJcmV0dXJuIGRlbnRyeTsKIAl9Cg==
--00000000000064959705e5fe9bf0--
