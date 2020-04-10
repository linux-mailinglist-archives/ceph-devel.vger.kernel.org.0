Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905101A4886
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Apr 2020 18:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgDJQcc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Apr 2020 12:32:32 -0400
Received: from alouette.ajlc.waterloo.on.ca ([45.55.22.104]:54504 "EHLO
        mail.ajlc.waterloo.on.ca" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDJQcc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 Apr 2020 12:32:32 -0400
Received: from [10.19.61.10] (et.ajlc.waterloo.on.ca [10.19.61.10])
        (authenticated bits=0)
        by mail.ajlc.waterloo.on.ca (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id 03AGWDM5013706;
        Fri, 10 Apr 2020 12:32:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ajlc.waterloo.on.ca;
        s=mail; t=1586536347;
        bh=wmXH6lLWnknq0J9z3XLIshT7NR6ssCasESszM9Yx6zk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=1VL4ROxw0yqZEgvincHR+Fc5HST1j/fIKRdlrr9LedVsv+KpIM3rh9ZsuSxOp3lli
         9mdWbtGp5SWUzGm0gwr6771LAx7yKoEAcGXVM5b1aMblPySQjmNTnTcxNbj0xnjnQd
         m3S1+VgbF15JVnEpndNzBvTI4djKkj5lD/gnz3wc=
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
To:     Jesper Krogh <jesper.krogh@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
 <db72c749125519b9c042c9664918eacbe8744985.camel@kernel.org>
 <CAED-sie+qsrr3yZVAiB=t6cAzWUwX9Y=32srJY2dwyRpSXvgxg@mail.gmail.com>
 <e9c9ffb60265aebdab6edd7ce1565402eb787270.camel@kernel.org>
 <CAED-sicefQuJ3GGWh2bBXz6R=BFr1EQ=h6Sz-W_mh3u+-tO0wA@mail.gmail.com>
 <cbbc31d2041601b3e0d2c9b1e8b657ffa23ed97e.camel@kernel.org>
 <CAED-sic=eDaXz-A6_ejZOYcJYs=-tJtmxXLcONdQRRCod59L_g@mail.gmail.com>
 <25bc975e164a73f18653156d6591dda785c8d0c1.camel@kernel.org>
 <f131fc4a-112d-2bea-f254-ed268579cf7e@ajlc.waterloo.on.ca>
 <CAED-side70b+sXVFS8Tvh+4uPXWGuHC08hcA95p1yXmdpM_-wA@mail.gmail.com>
From:   Tony Lill <ajlill@ajlc.waterloo.on.ca>
Openpgp: preference=signencrypt
Autocrypt: addr=ajlill@ajlc.waterloo.on.ca; prefer-encrypt=mutual; keydata=
 xsDiBElr2s8RBADQ/z/SOK+RLMLYCrsWDKJipgxMyCauAEFppc/xSpdTh9RASxo0B22T+M+/
 +LKxZdTfNBklVrh4I8h2w4QsVU0HZoN8XBcuq0B7qlXS1lgmPrzK0YYgpBDhe4hU7Bi8tIRI
 jAbvASyKdRpQg+RhSU1Om8xU5ShWdQKfNrsC7k0hnwCggEaxniaqNNrie3KO/TgHflGby7UE
 AM4DjY+2TvEuL8p4u9So3NxLlk/5NShEjDyOmXS4SwlKHtgYORP1UNDFJiEzlZwc6SSmHDmC
 1KvCSjSGxPVA3ZM6AIdQjCl2gAGu56srT3O7XrU8A/LvvURRu8fIyWsaLg/W/BchZqBxFyyL
 UlgEqHjhkJU6RnvrjfNhUBNM2z7GBACVke9sXdfuOgPby0RTnnAucta+cSRGWn4QbZ1ooIsX
 ohW2RNcYhjOUJLjneuMh/pO8j+9ZnO8swWmuyA6vequXe512C3IKEyDcVOS/s+7ad4eG7Lii
 +T5uWnCcCEPM5VmvrbgRVKXuRpL8CVMGtluu7LkN+FzW4RgQwQHLORIB/s0pQW50aG9ueSBM
 aWxsIDxhamxpbGxAYWpsYy53YXRlcmxvby5vbi5jYT7CYAQTEQIAIAUCSWvazwIbAwYLCQgH
 AwIEFQIIAwQWAgMBAh4BAheAAAoJEBkvMmatbr8QsegAn2+XRggKHprd7M78Zvp2Y4q6cX9N
 AJ4+LLclxk3xoPJmkmAxEWKBWOOYrc7BTQRJa9rREAgAxqqVSPsqBXym2GcKZ516l5lLdsJn
 PDj0VbYh3Be3TrGiwYfH6gn2Tq/5S8jwkgCLVNjmKv2kmwYA467+0YcMQpx279zfEwA4M1ry
 TLLFIJnSnRjTd/3ULRPjnyBhkRggnR+nhiUICr4vcGIXfmU5cB1KaE3q2qThmmeKQ7J6nhTU
 BYso+8viXP1Y3LBAO5HBjqR5lXWQPfwqGVKXamErspiZAy4F0WpC51nSmOxTbqvuIyvQA+/z
 crH+7937Knz+D5g8HU9kXU/XCpbAShQf0VdkbdedsxMGymuS/AwinPlJr+jPuHF9mi0fKPYQ
 PYn204DwWe5jDUJLCe0Al76d1wADBwgAj2Bz1+3Yl4mjNSHhO42jPc5PrPBF/ADYmb2X7mMA
 52t8POn1R83eQgHyuFCw/vPiu67S9EAQ5cUZbqVlb1spuSNlmdPnZ2NLLb4XEUSD6Rr01uxE
 O1XREi9CDrIocQyUkoakIyazzn/ltMefyHxRSo66JyXxrPivC09ZQViL9bLf7qZ2FQc40A+1
 zw5xMhNxJRIwP9RRo8aU2EE3NnnPdLR30KxFGjxPwYUtq73oZobkRpX4eGLlhyNdRydUHmfa
 T+0gXUxf3uSMx2Xz02BShx7zA8FvtwZCU9sWCxbcZPP1/PVZJkWQMGbUfGU7GeuEH+OBLbo7
 vvZSXoQrp8k7TsJJBBgRAgAJBQJJa9rRAhsMAAoJEBkvMmatbr8QTfsAnRQPsqJofLOxaFkI
 36psGu60ilooAJ4jsO8z6GSx92YKBl8cZO/z0ZTi7g==
Message-ID: <141990e9-11d4-7440-a8b5-870e2f14010a@ajlc.waterloo.on.ca>
Date:   Fri, 10 Apr 2020 12:32:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAED-side70b+sXVFS8Tvh+4uPXWGuHC08hcA95p1yXmdpM_-wA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="l7uTXsFlwdEdiGLuOdZoPfe3ocNsfakaz"
X-Spam-Status: No, score=-101.2 required=5.0 tests=ALL_TRUSTED,AWL,
        USER_IN_WHITELIST autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        mail.ajlc.waterloo.on.ca
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l7uTXsFlwdEdiGLuOdZoPfe3ocNsfakaz
Content-Type: multipart/mixed; boundary="1RjRKoiZuPHtw0L0lEgHkoMRH7bloJj6L";
 protected-headers="v1"
From: Tony Lill <ajlill@ajlc.waterloo.on.ca>
To: Jesper Krogh <jesper.krogh@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, ceph-devel <ceph-devel@vger.kernel.org>
Message-ID: <141990e9-11d4-7440-a8b5-870e2f14010a@ajlc.waterloo.on.ca>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
 <db72c749125519b9c042c9664918eacbe8744985.camel@kernel.org>
 <CAED-sie+qsrr3yZVAiB=t6cAzWUwX9Y=32srJY2dwyRpSXvgxg@mail.gmail.com>
 <e9c9ffb60265aebdab6edd7ce1565402eb787270.camel@kernel.org>
 <CAED-sicefQuJ3GGWh2bBXz6R=BFr1EQ=h6Sz-W_mh3u+-tO0wA@mail.gmail.com>
 <cbbc31d2041601b3e0d2c9b1e8b657ffa23ed97e.camel@kernel.org>
 <CAED-sic=eDaXz-A6_ejZOYcJYs=-tJtmxXLcONdQRRCod59L_g@mail.gmail.com>
 <25bc975e164a73f18653156d6591dda785c8d0c1.camel@kernel.org>
 <f131fc4a-112d-2bea-f254-ed268579cf7e@ajlc.waterloo.on.ca>
 <CAED-side70b+sXVFS8Tvh+4uPXWGuHC08hcA95p1yXmdpM_-wA@mail.gmail.com>
In-Reply-To: <CAED-side70b+sXVFS8Tvh+4uPXWGuHC08hcA95p1yXmdpM_-wA@mail.gmail.com>

--1RjRKoiZuPHtw0L0lEgHkoMRH7bloJj6L
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 4/10/20 3:13 AM, Jesper Krogh wrote:
> Hi. What is the suggested change? - is it Ceph that has an rsize,wsize
> of 64MB ?
>=20

Sorry, set rsize and wsize in the mount options for your cephfs to
something smaller.

My problem with this is that I use autofs to mount my filesystem.
Starting with 4.14.82, after a few mount/unmount cycles, the mount would
fail with order 4 allocation error, and I'd have to reboot.

I traced it to a change that doubled CEPH_MSG_MAX_DATA_LEN from 16M to
32M. Later in the 5 series kernels, this was doubled again, and that
caused an order 5 allocation failure. This define is used to set the max
and default rsize and wsize.

Reducing the rsize and wsize in the mount option fixed the problem for
me. This may do nothing for you, but, if it clears your allocation issue.=
=2E.


> On Fri, Apr 10, 2020 at 12:47 AM Tony Lill <ajlill@ajlc.waterloo.on.ca>=
 wrote:
>>
>>
>>
>> On 4/9/20 12:30 PM, Jeff Layton wrote:
>>> On Thu, 2020-04-09 at 18:00 +0200, Jesper Krogh wrote:
>>>> Thanks Jeff - I'll try that.
>>>>
>>>> I would just add to the case that this is a problem we have had on a=

>>>> physical machine - but too many "other" workloads at the same time -=

>>>> so we isolated it off to a VM - assuming that it was the mixed
>>>> workload situation that did cause us issues. I cannot be sure that i=
t
>>>> is "excactly" the same problem we're seeing but symptoms are
>>>> identical.
>>>>
>>>
>>> Do you see the "page allocation failure" warnings on bare metal hosts=

>>> too? If so, then maybe we're dealing with a problem that isn't
>>> virtio_net specific. In any case, let's get some folks more familiar
>>> with that area involved first and take it from there.
>>>
>>> Feel free to cc me on the bug report too.
>>>
>>> Thanks,
>>>
>>
>> In 5.4.20, the default rsize and wsize is 64M. This has caused me page=

>> allocation failures in a different context. Try setting it to somethin=
g
>> sensible.
>> --
>> Tony Lill, OCT,                     ajlill@AJLC.Waterloo.ON.CA
>> President, A. J. Lill Consultants               (519) 650 0660
>> 539 Grand Valley Dr., Cambridge, Ont. N3H 2S2   (519) 241 2461
>> -------------- http://www.ajlc.waterloo.on.ca/ ---------------
>>
>>
>>

--=20
Tony Lill, OCT,                     ajlill@AJLC.Waterloo.ON.CA
President, A. J. Lill Consultants               (519) 650 0660
539 Grand Valley Dr., Cambridge, Ont. N3H 2S2   (519) 241 2461
-------------- http://www.ajlc.waterloo.on.ca/ ---------------




--1RjRKoiZuPHtw0L0lEgHkoMRH7bloJj6L--

--l7uTXsFlwdEdiGLuOdZoPfe3ocNsfakaz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAl6Qn4cACgkQGS8yZq1uvxBaNwCcDfmfifnuLOTkiKp/pHOq3WAT
MR0AmQFVzJEPkOihPFuUxq5ommBFrV6H
=wCL0
-----END PGP SIGNATURE-----

--l7uTXsFlwdEdiGLuOdZoPfe3ocNsfakaz--
