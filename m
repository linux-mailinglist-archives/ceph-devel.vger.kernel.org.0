Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685F167D7F2
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Jan 2023 22:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjAZVxf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Jan 2023 16:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjAZVxe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 Jan 2023 16:53:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7187167B
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 13:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674769925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S85UsRzvZQYkTBKSceyocQTqqLH5TMTs40zJAWm4tFI=;
        b=dnBPeN6h8AMfocT5kko4NOlY5XHfaPtdF1Wacgjiqah1D2iUjdTZSzSt32kkyzkAUkQf3r
        W2KEM4VWRvfe8LiuTGZbtEEQzT5z7uXKWB5kOMMii9mv+H3YXc8dInYCTNHbZSEKyfuKT4
        6avKSEidQCWNmNGeAQm+iT2Qk4zpHDw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-wV0OtDMPOH-CAD-JtIFcRw-1; Thu, 26 Jan 2023 16:52:00 -0500
X-MC-Unique: wV0OtDMPOH-CAD-JtIFcRw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E5DA29AA382;
        Thu, 26 Jan 2023 21:52:00 +0000 (UTC)
Received: from localhost (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CEB251E5;
        Thu, 26 Jan 2023 21:51:59 +0000 (UTC)
Date:   Thu, 26 Jan 2023 16:51:57 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Maged Mokhtar <mmokhtar@petasan.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, vromanso@redhat.com, kwolf@redhat.com,
        mimehta@redhat.com, acardace@redhat.com
Subject: Re: rbd kernel block driver memory usage
Message-ID: <Y9L1/fK6M0Co4q9a@fedora>
References: <Y9FffDxl2sa9762M@fedora>
 <CAOi1vP8+nQMsGPK-SW-FG4C2HAgp76dEHeTEwQ2xxi2oJLH1aA@mail.gmail.com>
 <Y9KP7EX9+Ub/StL/@fedora>
 <b7021070-0d40-362c-51ab-666922c153a6@petasan.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iM7RHbsrI9xOGHBl"
Content-Disposition: inline
In-Reply-To: <b7021070-0d40-362c-51ab-666922c153a6@petasan.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--iM7RHbsrI9xOGHBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 26, 2023 at 08:14:22PM +0200, Maged Mokhtar wrote:
> in case of object map which the driver loads, takes 2 bits per 4 MB of im=
age
> size. 16 TB image requires 1 MB of memory.
>=20
> > > I was trying to get a sense ofwhether to look deeper into the rbd dri=
ver in a OOM kill scenario.
>=20
> If you are looking into OOM, maybe look into lowering queue_depth which y=
ou can specify when you map the image. Technically it belongs to the block =
layer queue rather than the rbd driver itself, If you write 4MB block size =
and your queue_depth is 1000, you need 4GB memory for inflight data for tha=
t single image, if you have many images it could add up.

Thanks!

Stefan

--iM7RHbsrI9xOGHBl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPS9f0ACgkQnKSrs4Gr
c8ivDwgAsbrnMzZapLKuvxV/IRG9GzERWB4v5myxCoMRZPH7wDgFWEqTQ+t6wxue
qp1ScG3wFZLNLS9AdVpuPLZ3RAsnKq1tpIPfZ1v3hux8gp7XHvZrBuqtQuNCWlu3
EchbuHrmDvLOU/SkIvA8aEXy4TiVw4wsCKGtXrI1lxLk74NGOGI7lHKSuLYAWCFr
3IYnXCzFC2N0mJYhivzjSJccWA2gPLUkgA/iUETBYk79GCx2+kUGiAWYic9E+lqb
nlzC7RlMDl6t5OHFsJBzS9ynx6jYyfAfeIUFrwUr4xI4VGZbS8/pOoMp1W+y/vLh
D1UMBsWHfFO4L/T+iV4BSlqGRrII6A==
=ZePB
-----END PGP SIGNATURE-----

--iM7RHbsrI9xOGHBl--

