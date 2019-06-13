Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EC8438D2
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jun 2019 17:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732923AbfFMPIp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jun 2019 11:08:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:50878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732377AbfFMN7m (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 09:59:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08CDEAC4E;
        Thu, 13 Jun 2019 13:59:40 +0000 (UTC)
Subject: Re: octopus planning calls
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
 <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal>
 <alpine.DEB.2.11.1906111326130.32406@piezo.novalocal>
 <alpine.DEB.2.11.1906121438520.4977@piezo.novalocal>
 <17f88e39-45d7-d13b-0c42-db1f07195c26@suse.com>
 <alpine.DEB.2.11.1906131354420.12100@piezo.novalocal>
From:   Kai Wagner <kwagner@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kwagner@suse.com; keydata=
 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
 NhINYeSuPh9mNyW2atrgHvmP6WPMmOI=
Message-ID: <b2e59205-8cb7-235f-5b1f-651af75480da@suse.com>
Date:   Thu, 13 Jun 2019 15:59:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1906131354420.12100@piezo.novalocal>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="7PD76QQXx7bgxag3HmXkaQ2yxFB2VF3IB"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7PD76QQXx7bgxag3HmXkaQ2yxFB2VF3IB
Content-Type: multipart/mixed; boundary="IDCDVNV7zEKNyvSe08DKFIuVXObfxU4az";
 protected-headers="v1"
From: Kai Wagner <kwagner@suse.com>
To: Sage Weil <sage@newdream.net>
Cc: ceph-devel@vger.kernel.org, dev@ceph.io
Message-ID: <b2e59205-8cb7-235f-5b1f-651af75480da@suse.com>
Subject: Re: octopus planning calls
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
 <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal>
 <alpine.DEB.2.11.1906111326130.32406@piezo.novalocal>
 <alpine.DEB.2.11.1906121438520.4977@piezo.novalocal>
 <17f88e39-45d7-d13b-0c42-db1f07195c26@suse.com>
 <alpine.DEB.2.11.1906131354420.12100@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906131354420.12100@piezo.novalocal>

--IDCDVNV7zEKNyvSe08DKFIuVXObfxU4az
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 13.06.19 15:56, Sage Weil wrote:
> Now we just need to figure out if that means November or March... :P
Mentioned exactly that in the dashboard planning meeting atm - the more
time the better ;-)

--=20
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=BC=
rnberg)



--IDCDVNV7zEKNyvSe08DKFIuVXObfxU4az--

--7PD76QQXx7bgxag3HmXkaQ2yxFB2VF3IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEIUhTiREAT2TdVpPQHoyRVhbjxG4FAl0CVsoACgkQHoyRVhbj
xG5PHgf/UqzP1ixRQlI3YIipX463pj02IR6Up0VJpRiNmAlPLoK4m4AXZjj0b/JX
oaAwxlogqO4/Is0VExZpFKASkZw7t1DR065Z4es7M+iceraMl2cFUp+d0s7e6nwe
zZQlSp5YKWfbdG7+i5Xgnk8DSB+kyt2/G6mzQ9LDUs5Di9fh646cy86HJvl2F+0U
DpeTLskF9G2qaaqNIPFUwx5aiG9jRui5bAXUcoE1CZm8su/+a4SxiNy0XptCpJfU
aS+RYGhVyVgat+OQmFfgpt4DERDLXQNqg2byj4XDzM2dUbEpuJkF/QGRXr028eDh
Sf/qblYDe1p6JZ4VZUdwOONFc9D15g==
=e4a3
-----END PGP SIGNATURE-----

--7PD76QQXx7bgxag3HmXkaQ2yxFB2VF3IB--
