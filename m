Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6473B3FF323
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 20:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346888AbhIBSUO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 14:20:14 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:54460
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233296AbhIBSUM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 14:20:12 -0400
Received: from [10.172.66.52] (1.general.drew.us.vpn [10.172.66.52])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 6659F3F232;
        Thu,  2 Sep 2021 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630606753;
        bh=XpiPJGwfmRhmIGWeDC6o+AuHmU1Zpc/CpKDXlKAgkok=;
        h=To:Cc:References:From:Subject:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=RQ1+00j5mMbo7slmd8cPRsu9gb9tCk5be8npdpAwlYEl2yxu7Q1+jRr4iqZV2AezD
         bVUUHnr0owwuy7eeCSoxeUpL7HO0UoVRILvdRIMCODmTFmLcXpbK0zL6+JX226AKH7
         0VeYwE0nfeyok/G/pwkPnUxqdQepF9CnGV4ZaWzj7CEYipy/ePsnPkjhae/DOhA8f3
         QEJu9fp+5bB3HIieys6LpgqjSzBmFWHTvkFFCNTZ8Z+2j/Ztq7vlITWjR6PLturVlY
         xf0X7VYTXmPAuBDwg5/nOTOCTogACTmp5RleU0QlwjUbXdLsx0KOO5tS+3aUQIrkS4
         pgdzbsdyNqjUg==
To:     Chris Dunlop <chris@onthe.net.au>,
        Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
References: <20210830234929.GA3817015@onthe.net.au>
 <CAJ4mKGZN+zAzyMM1+mWuPw5r1v=b-QQrChm+_0nfWtzcbyx=_g@mail.gmail.com>
 <20210902014125.GA13333@onthe.net.au>
From:   Drew Freiberger <drew.freiberger@canonical.com>
Autocrypt: addr=drew.freiberger@canonical.com; keydata=
 xsBNBFiGVQ0BCADZZG74lXdw+B4Jg0uz0QYO4oDLgc0hUVoTRpYKsuwAKvEp18HYobbLnI5C
 4MPHhUQS+GGq541W7JMp5kjUPLNx1fb26fGVMkBeVUOPZXaIID+n/5RP9Hid4anHwftUCRNd
 nZHYCtvlmS13dsw3H3oNwxWS1rY8z/XaChUMmBOsqffU8cPeX3sILhveFE0h4mTrnImK+7dP
 wIiPLKByYd9QcmtTkTXpBV8IuSnWVJyaMcoY+bXo59BRpeBX89c9OPm2DF4VprOwr6J2FfHL
 dUjnZHKvUQLXSzStWNZStXNFwGTwdPBLXHaw/LOyeNyLl4SVXukgCv2Q6jd62KGd/TNhABEB
 AAHNQ0FuZHJldyBGcmVpYmVyZ2VyIChEcmV3IEZyZWliZXJnZXIpIDxkcmV3LmZyZWliZXJn
 ZXJAY2Fub25pY2FsLmNvbT7CwHcEEwEIACEFAliGVQ0CGwMFCwkIBwIGFQgJCgsCBBYCAwEC
 HgECF4AACgkQyqT24SKUKlg9WAf9GyQQesFl9xa5mwHGd18uB2wPUvwkv32YbNvAdNMRcHmc
 lnbBBeHwbmPHSnVeN1KFl0UU5PRRtPmCzyJcuBzJeFgVQ0aNfhCn+9QB/dFjg4c+BKZ7mqmA
 nRBtTp6F86v0fFCKts1l7efFmBuSMC4WkkpYD26lWStHWFNuYm9h7amoE9Vkwle9LvKdzSKx
 Qo3iVOvQ+htl/sOIJtI7Uymj3fuBkD1qMaGBVXGVdKYnSLMEaXj+A1rMDSjcWpRJRthcnNIx
 lsxeErT/QrhpZAZ66+J/TV3FxX0KHnBvys8nmdJ+PLzDwfNb5+3h4TB6SsJzZZPHYIG+d88f
 k1Rd0pOd6s7ATQRYhlUNAQgAyWP/GHMJnrgdsXX0WSesQWtAu7wO8RvCns1qyuxlLQum0ovo
 EvsEcZxi06lxgIhMOUqX6zPXuX2kFH7iK5fvlo68+4j8Qtk9pQXCBwQAjzUMpc4VLmHfcnam
 l4NQnNxe3/k2h6FWUwfQc1VE7pGnbcNit/mwHKdx/xhMF9cPZ8JUn6ok8ibyduQYZhYI1woH
 bEUgn1DJdj6av2dDMg5Q9y93qQCvRtwKo76mlNJFxS/WBT/o3VsQJcVsq0tSaKCsNGv6Prxr
 JhcrbXg2GDw6R05CLVOKjAKnm83HSnlha9w29IG3Hl6hd1BL0NOYD+k+ug7oKjOTwpnbrmRi
 t9ZEtQARAQABwsBfBBgBCAAJBQJYhlUNAhsMAAoJEMqk9uEilCpYf5cH/2/TqH67loXkLbyy
 Fi1ZvkqZd0rH1GVgiD90/vtq2R4z5VaS3AQHm33HvqexMXOWqII1eE33Ic6J1fxwyrQEnOrj
 jt1NuUMlsPsfKDrqhEDqIDxO807SCNzB+8fE6Om66Zad5TnhW25SbzrZqEq8Ht8JcLk3vLH8
 F14cdGwbUu+gDIP3U/eUzTPHQfI9RQ0d1duwgYxEuhkU/7Pmsy6WF6MFIIOlsJZjccH14/oj
 b2kMba25XIS39SoGZ6WTDJeTco9XIxPQVgXCPzEkIVcObHzEBmNA1ZYJtPt2W89heMZ/pdST
 +dFeh5fEsZtM8wuqabtGFIc7dIGI6lyDJ3nDgs4=
Subject: Re: New pacific mon won't join with octopus mons
Message-ID: <e48c8f1a-b6ac-e811-cd45-ffba451a133e@canonical.com>
Date:   Thu, 2 Sep 2021 13:19:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210902014125.GA13333@onthe.net.au>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Rfe6sDJdutPZHKedjUTmGdfGzBtdRWa75"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Rfe6sDJdutPZHKedjUTmGdfGzBtdRWa75
Content-Type: multipart/mixed; boundary="BcPI3T3Wr1iMNy6M4fkwr1SuFwuxqGu6Q";
 protected-headers="v1"
From: Drew Freiberger <drew.freiberger@canonical.com>
To: Chris Dunlop <chris@onthe.net.au>, Gregory Farnum <gfarnum@redhat.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>
Message-ID: <e48c8f1a-b6ac-e811-cd45-ffba451a133e@canonical.com>
Subject: Re: New pacific mon won't join with octopus mons
References: <20210830234929.GA3817015@onthe.net.au>
 <CAJ4mKGZN+zAzyMM1+mWuPw5r1v=b-QQrChm+_0nfWtzcbyx=_g@mail.gmail.com>
 <20210902014125.GA13333@onthe.net.au>
In-Reply-To: <20210902014125.GA13333@onthe.net.au>

--BcPI3T3Wr1iMNy6M4fkwr1SuFwuxqGu6Q
Content-Type: multipart/mixed;
 boundary="------------A02A9CCC9BDD795859F5C93A"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------A02A9CCC9BDD795859F5C93A
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Given your history of being on pre-octopus release on this environment=20
and having gone through other upgrades, have you ensured you've=20
completed all steps of the upgrade and set your minimum versions per the =

documentation?=C2=A0 I've seen where octopus will drop nautilus osds if t=
he=20
osd_minimum_version wasn't set to nautilus before introduction of the=20
octopus mons.=C2=A0 I wonder if you're running into something similar wit=
h=20
the o->p upgrade.

Check here for further details about completing upgrades (this started=20
in Luminous series):

https://ceph.io/en/news/blog/2017/new-luminous-upgrade-complete/

-Drew

On 9/1/21 8:41 PM, Chris Dunlop wrote:
> Hi Gregory,
>
> On Wed, Sep 01, 2021 at 10:56:56AM -0700, Gregory Farnum wrote:
>> Why are you trying to create a new pacific monitor instead of
>> upgrading an existing one?
>
> The "ceph orch upgrade" failed twice at the point of upgrading the=20
> mons, once due to the octopus mons getting the "--init" argument added =

> to their docker startup and the docker version on Debian Buster not=20
> supporting both the "--init" and "-v /dev:/dev" args at the same time, =

> per:
>
> https://github.com/moby/moby/pull/37665
>
> ...and once due to never having a cephfs on the cluster:
>
> https://tracker.ceph.com/issues/51673
>
> So at one point I had one mon down due to the failed upgrade, then=20
> another of the 3 originals was taken out by the host's disk filling up =

> (due, I think, to the excessive logging occurring at the time in=20
> combination with having both docker and podman images pulled in),=20
> leaving me with a single octopus mon running and no quorum, bringing=20
> the cluster to a stand still, and me panic-learning how to deal with=20
> the situation. Fun times.
>
> So yes, I was feeling just a little leery about upgrading the octopus=20
> mons and potentialy losing quorum again!
>
>> I *think* what's going on here is that since you're deploying a new
>> pacific mon, and you're not giving it a starting monmap, it's set up
>> to assume the use of pacific features. It can find peers at the
>> locations you've given it, but since they're on octopus there are
>> mismatches.
>>
>> Now, I would expect and want this to work so you should file a bug,
>
> https://tracker.ceph.com/issues/52488
>
>> but the initial bootstrapping code is a bit hairy and may not account
>> for cross-version initial setup in this fashion, or have gotten buggy
>> since written. So I'd try upgrading the existing mons, or generating a=

>> new pacific mon and upgrading that one to octopus if you're feeling
>> leery.
>
> Yes, I thought a safer / less stressful way of progressing would be to =

> add a new octopus mon to the existing quorum and upgrade that one=20
> first as a test. I went ahead with that and checked the cluster health =

> immediately afterwards: "ceph -s" showed HEALTH_OK, with 4 mons, i.e.=20
> 3 x octopus and 1 x pacific.
>
> Nice!
> But shortly later alarms started going off and the health of the=20
> cluster was coming back as more than a little gut-wrenching, with ALL=20
> pgs showing up as inactive / unknown:
>
> $ ceph -s
> =C2=A0 cluster:
> =C2=A0=C2=A0=C2=A0 id:=C2=A0=C2=A0=C2=A0=C2=A0 c6618970-0ce0-4cb2-bc9a-=
dd5f29b62e24
> =C2=A0=C2=A0=C2=A0 health: HEALTH_WARN
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Redu=
ced data availability: 5721 pgs inactive
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (mut=
ed: OSDMAP_FLAGS POOL_NO_REDUNDANCY)
>
> =C2=A0 services:
> =C2=A0=C2=A0=C2=A0 mon: 4 daemons, quorum k2,b2,b4,b5 (age 43m)
> =C2=A0=C2=A0=C2=A0 mgr: b5(active, starting, since 40m), standbys: b4, =
b2
> =C2=A0=C2=A0=C2=A0 osd: 78 osds: 78 up (since 4d), 78 in (since 3w)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flags noout
>
> =C2=A0 data:
> =C2=A0=C2=A0=C2=A0 pools:=C2=A0=C2=A0 12 pools, 5721 pgs
> =C2=A0=C2=A0=C2=A0 objects: 0 objects, 0 B
> =C2=A0=C2=A0=C2=A0 usage:=C2=A0=C2=A0 0 B used, 0 B / 0 B avail
> =C2=A0=C2=A0=C2=A0 pgs:=C2=A0=C2=A0=C2=A0=C2=A0 100.000% pgs unknown
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 5721 unknown
>
> $ ceph health detail
> HEALTH_WARN Reduced data availability: 5721 pgs inactive; (muted:=20
> OSDMAP_FLAGS POOL_NO_REDUNDANCY)
> (MUTED) [WRN] OSDMAP_FLAGS: noout flag(s) set
> [WRN] PG_AVAILABILITY: Reduced data availability: 5721 pgs inactive
> =C2=A0=C2=A0=C2=A0 pg 6.fcd is stuck inactive for 41m, current state un=
known, last=20
> acting []
> =C2=A0=C2=A0=C2=A0 pg 6.fce is stuck inactive for 41m, current state un=
known, last=20
> acting []
> =C2=A0=C2=A0=C2=A0 pg 6.fcf is stuck inactive for 41m, current state un=
known, last=20
> acting []
> =C2=A0=C2=A0=C2=A0 pg 6.fd0 is stuck inactive for 41m, current state un=
known, last=20
> acting []
> =C2=A0=C2=A0=C2=A0 ...etc.
>
> So that was also heaps of fun for a while, until I thought to remove=20
> the pacific mon and the health reverted to normal. Bug filed:
>
> https://tracker.ceph.com/issues/52489
>
> At this point I'm more than a little gun shy, but I'm girding my loins =

> to go ahead with the rest of the upgrade on the basis the health issue =

> is "just" a temporary reporting problem (albeit a highly startling=20
> one!) with mixed octopus and pacific mons.
>
> Cheers,
>
> Chris


--------------A02A9CCC9BDD795859F5C93A
Content-Type: application/pgp-keys;
 name="OpenPGP_0xCAA4F6E122942A58.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
Content-Disposition: attachment;
 filename="OpenPGP_0xCAA4F6E122942A58.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFiGVQ0BCADZZG74lXdw+B4Jg0uz0QYO4oDLgc0hUVoTRpYKsuwAKvEp18HYobbLnI5C4=
MPH
hUQS+GGq541W7JMp5kjUPLNx1fb26fGVMkBeVUOPZXaIID+n/5RP9Hid4anHwftUCRNdnZHYC=
tvl
mS13dsw3H3oNwxWS1rY8z/XaChUMmBOsqffU8cPeX3sILhveFE0h4mTrnImK+7dPwIiPLKByY=
d9Q
cmtTkTXpBV8IuSnWVJyaMcoY+bXo59BRpeBX89c9OPm2DF4VprOwr6J2FfHLdUjnZHKvUQLXS=
zSt
WNZStXNFwGTwdPBLXHaw/LOyeNyLl4SVXukgCv2Q6jd62KGd/TNhABEBAAHNQ0FuZHJldyBGc=
mVp
YmVyZ2VyIChEcmV3IEZyZWliZXJnZXIpIDxkcmV3LmZyZWliZXJnZXJAY2Fub25pY2FsLmNvb=
T7C
wHcEEwEIACEFAliGVQ0CGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQyqT24SKUKlg9W=
Af9
GyQQesFl9xa5mwHGd18uB2wPUvwkv32YbNvAdNMRcHmclnbBBeHwbmPHSnVeN1KFl0UU5PRRt=
PmC
zyJcuBzJeFgVQ0aNfhCn+9QB/dFjg4c+BKZ7mqmAnRBtTp6F86v0fFCKts1l7efFmBuSMC4Wk=
kpY
D26lWStHWFNuYm9h7amoE9Vkwle9LvKdzSKxQo3iVOvQ+htl/sOIJtI7Uymj3fuBkD1qMaGBV=
XGV
dKYnSLMEaXj+A1rMDSjcWpRJRthcnNIxlsxeErT/QrhpZAZ66+J/TV3FxX0KHnBvys8nmdJ+P=
LzD
wfNb5+3h4TB6SsJzZZPHYIG+d88fk1Rd0pOd6s7ATQRYhlUNAQgAyWP/GHMJnrgdsXX0WSesQ=
WtA
u7wO8RvCns1qyuxlLQum0ovoEvsEcZxi06lxgIhMOUqX6zPXuX2kFH7iK5fvlo68+4j8Qtk9p=
QXC
BwQAjzUMpc4VLmHfcnaml4NQnNxe3/k2h6FWUwfQc1VE7pGnbcNit/mwHKdx/xhMF9cPZ8JUn=
6ok
8ibyduQYZhYI1woHbEUgn1DJdj6av2dDMg5Q9y93qQCvRtwKo76mlNJFxS/WBT/o3VsQJcVsq=
0tS
aKCsNGv6PrxrJhcrbXg2GDw6R05CLVOKjAKnm83HSnlha9w29IG3Hl6hd1BL0NOYD+k+ug7oK=
jOT
wpnbrmRit9ZEtQARAQABwsBfBBgBCAAJBQJYhlUNAhsMAAoJEMqk9uEilCpYf5cH/2/TqH67l=
oXk
LbyyFi1ZvkqZd0rH1GVgiD90/vtq2R4z5VaS3AQHm33HvqexMXOWqII1eE33Ic6J1fxwyrQEn=
Orj
jt1NuUMlsPsfKDrqhEDqIDxO807SCNzB+8fE6Om66Zad5TnhW25SbzrZqEq8Ht8JcLk3vLH8F=
14c
dGwbUu+gDIP3U/eUzTPHQfI9RQ0d1duwgYxEuhkU/7Pmsy6WF6MFIIOlsJZjccH14/ojb2kMb=
a25
XIS39SoGZ6WTDJeTco9XIxPQVgXCPzEkIVcObHzEBmNA1ZYJtPt2W89heMZ/pdST+dFeh5fEs=
ZtM
8wuqabtGFIc7dIGI6lyDJ3nDgs4=3D
=3DoldL
-----END PGP PUBLIC KEY BLOCK-----

--------------A02A9CCC9BDD795859F5C93A--

--BcPI3T3Wr1iMNy6M4fkwr1SuFwuxqGu6Q--

--Rfe6sDJdutPZHKedjUTmGdfGzBtdRWa75
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEOfrMJFPadkQGDdl7yqT24SKUKlgFAmExFZsACgkQyqT24SKU
Klg+GwgAsvxRH6BLnkDQ7wK1tS/C5LH2m+wl0PxijX/x9nnixJGuLDqKkSFg19WO
tlNDj/SJZQcEOMeKw3igFNFFAzY715QQkA/I4NyCPFD/1nnmcCb7nMZNuDPUdwxD
yaR19RaWuDTxEauMyn0+xK8/MgEMTrG/b5SKcn9VZhpkPkwikbwCr+URExbvqBbT
C5kn++r8UPVnRgI/0PzfJu8RC90bfdjX9L5EdmePHjhHumGc/GTSZvAKYywMa+mP
tFxgeExxk6ir3AfLgS8Ajy1VMIo9IN4qQHvwtcpSEH/ft6VqsG8by4SBEBHSNjT/
JqyZnxlrZHF1fpPQU3mMRTNMjfczcg==
=C8lJ
-----END PGP SIGNATURE-----

--Rfe6sDJdutPZHKedjUTmGdfGzBtdRWa75--
