Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A8E1277EE
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Dec 2019 10:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfLTJVq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Dec 2019 04:21:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49408 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727177AbfLTJVq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 Dec 2019 04:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576833704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OggZnqrMQnWlBkFE7UHLAXY6DiIuktt+ciazSHsR/O4=;
        b=d6rsF7JQRKpTCNrtQech+G11ji31kEi24zYxcKWP4wZxLnuq6546XTZsXpuHJ7GEysvtrO
        xYZyLJoT0Qzs4rSobQprjVRfuyy8bbCa1LxU2ZeElJ4Yftgjes5Z2QieShjzmpfHUb15li
        HFSld/kNra0BO55fBqSX9wC2/+WQQ9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-0bO5ezOfNmaKGive1xD5lQ-1; Fri, 20 Dec 2019 04:21:40 -0500
X-MC-Unique: 0bO5ezOfNmaKGive1xD5lQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A676107ACC4;
        Fri, 20 Dec 2019 09:21:39 +0000 (UTC)
Received: from [10.72.12.19] (ovpn-12-19.pek2.redhat.com [10.72.12.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6FF75DA76;
        Fri, 20 Dec 2019 09:21:33 +0000 (UTC)
Subject: Re: [PATCH v3] ceph: rename get_session and switch to use
 ceph_get_mds_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20191220004409.12793-1-xiubli@redhat.com>
 <CAOi1vP85em7ase08xywaOTfaxrsMq7Y9yeYcxcgKz8QH=oxOGQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ca915587-290a-fb10-2fd6-8a5d5bbb4fc0@redhat.com>
Date:   Fri, 20 Dec 2019 17:21:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP85em7ase08xywaOTfaxrsMq7Y9yeYcxcgKz8QH=oxOGQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------74909DFC188F187C1BF2A06C"
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------74909DFC188F187C1BF2A06C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2019/12/20 17:11, Ilya Dryomov wrote:
> On Fri, Dec 20, 2019 at 1:44 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Just in case the session's refcount reach 0 and is releasing, and
>> if we get the session without checking it, we may encounter kernel
>> crash.
>>
>> Rename get_session to ceph_get_mds_session and make it global.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V3:
>> - Clean all the local commit and pull it and rebased again, it is based
>>    the following commit:
>>
>>    commit 3a1deab1d5c1bb693c268cc9b717c69554c3ca5e
>>    Author: Xiubo Li <xiubli@redhat.com>
>>    Date:   Wed Dec 4 06:57:39 2019 -0500
>>
>>        ceph: add possible_max_rank and make the code more readable
> Hi Xiubo,
>
> The base is correct, but the patch still appears to have been
> corrupted, either by your email client or somewhere in transit.

Ah, I have no idea of this now, I was doing the following command to 
post it:

# git send-email --smtp-server=... --to=...

And my git version is:

# git --version
git version 2.21.0

I attached it or should I post it again ?

Thanks.


> Thanks,
>
>                  Ilya
>


--------------74909DFC188F187C1BF2A06C
Content-Type: text/plain; charset=UTF-8;
 name="0001-ceph-rename-get_session-and-switch-to-use-ceph_get_m.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-ceph-rename-get_session-and-switch-to-use-ceph_get_m.pa";
 filename*1="tch"

RnJvbSBlMTliYjMxZmE3NDMwOWYyYjY0YzgyOTQxMjczOTJkNzE5ZjU3MDhlIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBYaXVibyBMaSA8eGl1YmxpQHJlZGhhdC5jb20+CkRh
dGU6IFdlZCwgMTggRGVjIDIwMTkgMDY6NDk6MzcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
ZXBoOiByZW5hbWUgZ2V0X3Nlc3Npb24gYW5kIHN3aXRjaCB0byB1c2UKIGNlcGhfZ2V0X21k
c19zZXNzaW9uCgpKdXN0IGluIGNhc2UgdGhlIHNlc3Npb24ncyByZWZjb3VudCByZWFjaCAw
IGFuZCBpcyByZWxlYXNpbmcsIGFuZAppZiB3ZSBnZXQgdGhlIHNlc3Npb24gd2l0aG91dCBj
aGVja2luZyBpdCwgd2UgbWF5IGVuY291bnRlciBrZXJuZWwKY3Jhc2guCgpSZW5hbWUgZ2V0
X3Nlc3Npb24gdG8gY2VwaF9nZXRfbWRzX3Nlc3Npb24gYW5kIG1ha2UgaXQgZ2xvYmFsLgoK
U2lnbmVkLW9mZi1ieTogWGl1Ym8gTGkgPHhpdWJsaUByZWRoYXQuY29tPgotLS0KIGZzL2Nl
cGgvbWRzX2NsaWVudC5jIHwgMTYgKysrKysrKystLS0tLS0tLQogZnMvY2VwaC9tZHNfY2xp
ZW50LmggfCAgOSArKy0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygr
KSwgMTUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2VwaC9tZHNfY2xpZW50LmMg
Yi9mcy9jZXBoL21kc19jbGllbnQuYwppbmRleCBkOGJiM2VlYmZhZWIuLmE2NGY5Y2NkYzJm
ZiAxMDA2NDQKLS0tIGEvZnMvY2VwaC9tZHNfY2xpZW50LmMKKysrIGIvZnMvY2VwaC9tZHNf
Y2xpZW50LmMKQEAgLTUzOCw3ICs1MzgsNyBAQCBjb25zdCBjaGFyICpjZXBoX3Nlc3Npb25f
c3RhdGVfbmFtZShpbnQgcykKIAl9CiB9CiAKLXN0YXRpYyBzdHJ1Y3QgY2VwaF9tZHNfc2Vz
c2lvbiAqZ2V0X3Nlc3Npb24oc3RydWN0IGNlcGhfbWRzX3Nlc3Npb24gKnMpCitzdHJ1Y3Qg
Y2VwaF9tZHNfc2Vzc2lvbiAqY2VwaF9nZXRfbWRzX3Nlc3Npb24oc3RydWN0IGNlcGhfbWRz
X3Nlc3Npb24gKnMpCiB7CiAJaWYgKHJlZmNvdW50X2luY19ub3RfemVybygmcy0+c19yZWYp
KSB7CiAJCWRvdXQoIm1kc2MgZ2V0X3Nlc3Npb24gJXAgJWQgLT4gJWRcbiIsIHMsCkBAIC01
NjksNyArNTY5LDcgQEAgc3RydWN0IGNlcGhfbWRzX3Nlc3Npb24gKl9fY2VwaF9sb29rdXBf
bWRzX3Nlc3Npb24oc3RydWN0IGNlcGhfbWRzX2NsaWVudCAqbWRzYywKIHsKIAlpZiAobWRz
ID49IG1kc2MtPm1heF9zZXNzaW9ucyB8fCAhbWRzYy0+c2Vzc2lvbnNbbWRzXSkKIAkJcmV0
dXJuIE5VTEw7Ci0JcmV0dXJuIGdldF9zZXNzaW9uKG1kc2MtPnNlc3Npb25zW21kc10pOwor
CXJldHVybiBjZXBoX2dldF9tZHNfc2Vzc2lvbihtZHNjLT5zZXNzaW9uc1ttZHNdKTsKIH0K
IAogc3RhdGljIGJvb2wgX19oYXZlX3Nlc3Npb24oc3RydWN0IGNlcGhfbWRzX2NsaWVudCAq
bWRzYywgaW50IG1kcykKQEAgLTE5OTAsNyArMTk5MCw3IEBAIHZvaWQgY2VwaF9mbHVzaF9j
YXBfcmVsZWFzZXMoc3RydWN0IGNlcGhfbWRzX2NsaWVudCAqbWRzYywKIAlpZiAobWRzYy0+
c3RvcHBpbmcpCiAJCXJldHVybjsKIAotCWdldF9zZXNzaW9uKHNlc3Npb24pOworCWNlcGhf
Z2V0X21kc19zZXNzaW9uKHNlc3Npb24pOwogCWlmIChxdWV1ZV93b3JrKG1kc2MtPmZzYy0+
Y2FwX3dxLAogCQkgICAgICAgJnNlc3Npb24tPnNfY2FwX3JlbGVhc2Vfd29yaykpIHsKIAkJ
ZG91dCgiY2FwIHJlbGVhc2Ugd29yayBxdWV1ZWRcbiIpOwpAQCAtMjYwNSw3ICsyNjA1LDcg
QEAgc3RhdGljIHZvaWQgX19kb19yZXF1ZXN0KHN0cnVjdCBjZXBoX21kc19jbGllbnQgKm1k
c2MsCiAJCQlnb3RvIGZpbmlzaDsKIAkJfQogCX0KLQlyZXEtPnJfc2Vzc2lvbiA9IGdldF9z
ZXNzaW9uKHNlc3Npb24pOworCXJlcS0+cl9zZXNzaW9uID0gY2VwaF9nZXRfbWRzX3Nlc3Np
b24oc2Vzc2lvbik7CiAKIAlkb3V0KCJkb19yZXF1ZXN0IG1kcyVkIHNlc3Npb24gJXAgc3Rh
dGUgJXNcbiIsIG1kcywgc2Vzc2lvbiwKIAkgICAgIGNlcGhfc2Vzc2lvbl9zdGF0ZV9uYW1l
KHNlc3Npb24tPnNfc3RhdGUpKTsKQEAgLTMxMjksNyArMzEyOSw3IEBAIHN0YXRpYyB2b2lk
IGhhbmRsZV9zZXNzaW9uKHN0cnVjdCBjZXBoX21kc19zZXNzaW9uICpzZXNzaW9uLAogCiAJ
bXV0ZXhfbG9jaygmbWRzYy0+bXV0ZXgpOwogCWlmIChvcCA9PSBDRVBIX1NFU1NJT05fQ0xP
U0UpIHsKLQkJZ2V0X3Nlc3Npb24oc2Vzc2lvbik7CisJCWNlcGhfZ2V0X21kc19zZXNzaW9u
KHNlc3Npb24pOwogCQlfX3VucmVnaXN0ZXJfc2Vzc2lvbihtZHNjLCBzZXNzaW9uKTsKIAl9
CiAJLyogRklYTUU6IHRoaXMgdHRsIGNhbGN1bGF0aW9uIGlzIGdlbmVyb3VzICovCkBAIC0z
ODA0LDcgKzM4MDQsNyBAQCBzdGF0aWMgdm9pZCBjaGVja19uZXdfbWFwKHN0cnVjdCBjZXBo
X21kc19jbGllbnQgKm1kc2MsCiAKIAkJaWYgKGkgPj0gbmV3bWFwLT5tX251bV9tZHMpIHsK
IAkJCS8qIGZvcmNlIGNsb3NlIHNlc3Npb24gZm9yIHN0b3BwZWQgbWRzICovCi0JCQlnZXRf
c2Vzc2lvbihzKTsKKwkJCWNlcGhfZ2V0X21kc19zZXNzaW9uKHMpOwogCQkJX191bnJlZ2lz
dGVyX3Nlc3Npb24obWRzYywgcyk7CiAJCQlfX3dha2VfcmVxdWVzdHMobWRzYywgJnMtPnNf
d2FpdGluZyk7CiAJCQltdXRleF91bmxvY2soJm1kc2MtPm11dGV4KTsKQEAgLTQ0MDQsNyAr
NDQwNCw3IEBAIHZvaWQgY2VwaF9tZHNjX2Nsb3NlX3Nlc3Npb25zKHN0cnVjdCBjZXBoX21k
c19jbGllbnQgKm1kc2MpCiAJbXV0ZXhfbG9jaygmbWRzYy0+bXV0ZXgpOwogCWZvciAoaSA9
IDA7IGkgPCBtZHNjLT5tYXhfc2Vzc2lvbnM7IGkrKykgewogCQlpZiAobWRzYy0+c2Vzc2lv
bnNbaV0pIHsKLQkJCXNlc3Npb24gPSBnZXRfc2Vzc2lvbihtZHNjLT5zZXNzaW9uc1tpXSk7
CisJCQlzZXNzaW9uID0gY2VwaF9nZXRfbWRzX3Nlc3Npb24obWRzYy0+c2Vzc2lvbnNbaV0p
OwogCQkJX191bnJlZ2lzdGVyX3Nlc3Npb24obWRzYywgc2Vzc2lvbik7CiAJCQltdXRleF91
bmxvY2soJm1kc2MtPm11dGV4KTsKIAkJCW11dGV4X2xvY2soJnNlc3Npb24tPnNfbXV0ZXgp
OwpAQCAtNDYzMiw3ICs0NjMyLDcgQEAgc3RhdGljIHN0cnVjdCBjZXBoX2Nvbm5lY3Rpb24g
KmNvbl9nZXQoc3RydWN0IGNlcGhfY29ubmVjdGlvbiAqY29uKQogewogCXN0cnVjdCBjZXBo
X21kc19zZXNzaW9uICpzID0gY29uLT5wcml2YXRlOwogCi0JaWYgKGdldF9zZXNzaW9uKHMp
KSB7CisJaWYgKGNlcGhfZ2V0X21kc19zZXNzaW9uKHMpKSB7CiAJCWRvdXQoIm1kc2MgY29u
X2dldCAlcCBvayAoJWQpXG4iLCBzLCByZWZjb3VudF9yZWFkKCZzLT5zX3JlZikpOwogCQly
ZXR1cm4gY29uOwogCX0KZGlmZiAtLWdpdCBhL2ZzL2NlcGgvbWRzX2NsaWVudC5oIGIvZnMv
Y2VwaC9tZHNfY2xpZW50LmgKaW5kZXggOWZiMjA2M2IwNjAwLi5hN2E5NGNmNTcxNTAgMTAw
NjQ0Ci0tLSBhL2ZzL2NlcGgvbWRzX2NsaWVudC5oCisrKyBiL2ZzL2NlcGgvbWRzX2NsaWVu
dC5oCkBAIC00NDMsMTUgKzQ0MywxMCBAQCBleHRlcm4gY29uc3QgY2hhciAqY2VwaF9tZHNf
b3BfbmFtZShpbnQgb3ApOwogZXh0ZXJuIHN0cnVjdCBjZXBoX21kc19zZXNzaW9uICoKIF9f
Y2VwaF9sb29rdXBfbWRzX3Nlc3Npb24oc3RydWN0IGNlcGhfbWRzX2NsaWVudCAqLCBpbnQg
bWRzKTsKIAotc3RhdGljIGlubGluZSBzdHJ1Y3QgY2VwaF9tZHNfc2Vzc2lvbiAqCi1jZXBo
X2dldF9tZHNfc2Vzc2lvbihzdHJ1Y3QgY2VwaF9tZHNfc2Vzc2lvbiAqcykKLXsKLQlyZWZj
b3VudF9pbmMoJnMtPnNfcmVmKTsKLQlyZXR1cm4gczsKLX0KLQogZXh0ZXJuIGNvbnN0IGNo
YXIgKmNlcGhfc2Vzc2lvbl9zdGF0ZV9uYW1lKGludCBzKTsKIAorZXh0ZXJuIHN0cnVjdCBj
ZXBoX21kc19zZXNzaW9uICoKK2NlcGhfZ2V0X21kc19zZXNzaW9uKHN0cnVjdCBjZXBoX21k
c19zZXNzaW9uICpzKTsKIGV4dGVybiB2b2lkIGNlcGhfcHV0X21kc19zZXNzaW9uKHN0cnVj
dCBjZXBoX21kc19zZXNzaW9uICpzKTsKIAogZXh0ZXJuIGludCBjZXBoX3NlbmRfbXNnX21k
cyhzdHJ1Y3QgY2VwaF9tZHNfY2xpZW50ICptZHNjLAotLSAKMi4yMS4wCgo=
--------------74909DFC188F187C1BF2A06C--

