Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2F5E6B9
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Apr 2019 17:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbfD2PlR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Apr 2019 11:41:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:41732 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728436AbfD2PlR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 11:41:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 55F3CAF56;
        Mon, 29 Apr 2019 15:41:15 +0000 (UTC)
Subject: Re: ceph-volume and multi-PV Volume groups
To:     Dan van der Ster <dan@vanderster.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <20190429150725.4b3sijovqn5hi4ik@jfsuselaptop>
 <CABZ+qqmL25T6D-tKMAvKMBaheb0i_gkZmn+C-oRET-VfoiOQmw@mail.gmail.com>
From:   Kai Wagner <kwagner@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kwagner@suse.com; keydata=
 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
 NhINYeSuPh9mNyW2atrgHvmP6WPMmOI=
Message-ID: <c7504be5-dd69-a0be-0eab-21ddc0a56bf5@suse.com>
Date:   Mon, 29 Apr 2019 17:41:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CABZ+qqmL25T6D-tKMAvKMBaheb0i_gkZmn+C-oRET-VfoiOQmw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="oxyZgv8K0Mk1gDod2RDyvD2NynyW5YwvZ"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oxyZgv8K0Mk1gDod2RDyvD2NynyW5YwvZ
Content-Type: multipart/mixed; boundary="WVSkxeZxvyN3Dij9WX2JwmAkP6Qbl3LAx";
 protected-headers="v1"
From: Kai Wagner <kwagner@suse.com>
To: Dan van der Ster <dan@vanderster.com>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Message-ID: <c7504be5-dd69-a0be-0eab-21ddc0a56bf5@suse.com>
Subject: Re: ceph-volume and multi-PV Volume groups
References: <20190429150725.4b3sijovqn5hi4ik@jfsuselaptop>
 <CABZ+qqmL25T6D-tKMAvKMBaheb0i_gkZmn+C-oRET-VfoiOQmw@mail.gmail.com>
In-Reply-To: <CABZ+qqmL25T6D-tKMAvKMBaheb0i_gkZmn+C-oRET-VfoiOQmw@mail.gmail.com>

--WVSkxeZxvyN3Dij9WX2JwmAkP6Qbl3LAx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 29.04.19 17:23, Dan van der Ster wrote:
> That said, I agree that the default should be to create a vg for each
> db device, because in addition to your tooling point below, (a) db's
> on a multi-dev linear vg is total nonsense imho, nobody wants that in
> prod, and (b) the tool seems arbitrarily inconsistent -- it creates a
> unique vg per data dev but one vg for all db devs! (one vg for all
> data devs is clearly bad, as is one vg for all db devices, imho).
Absolutely agree here as well. The default should be changed as you've
explained already otherwise it makes no sense to me either.

--=20
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=BC=
rnberg)



--WVSkxeZxvyN3Dij9WX2JwmAkP6Qbl3LAx--

--oxyZgv8K0Mk1gDod2RDyvD2NynyW5YwvZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEIUhTiREAT2TdVpPQHoyRVhbjxG4FAlzHGxoACgkQHoyRVhbj
xG7TTAgAgEsyySz63iv2UGBc3Kq1t25KuqY/+KE36QgGtAPoBhM9bPx+DqLOad7n
RcBjC/z6rIrjDsmwf3tGKXetikqmvKQwhuTzo9hXCaQ8OpV3L5wL6gQ/Wo9t6QP2
B69MNrbTHQQdytz/lhNCrxHzo4OhRuKFq5K4K4Tx8dHH8y5d19qOh7SimDb5Y6MU
V0MVrboRd26scD4wtVh+LmQWmTz0YqmA74VDIg8TSd/46xgsn5lpHLUN/QzTUOBm
dpNkIceBBQaysPi2toYBnIrJOObcaQsGI7QNJhH6D31OoUqz1P8WPoPOy0+RiBPN
4P3c4WEnGaRlpWWmzqQ1sMRFbYCA+Q==
=9mYz
-----END PGP SIGNATURE-----

--oxyZgv8K0Mk1gDod2RDyvD2NynyW5YwvZ--
