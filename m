Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7191867CE4F
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Jan 2023 15:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjAZOhd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Jan 2023 09:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjAZOh3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 Jan 2023 09:37:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2873023862
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 06:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674743803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h0oiMlDDsyNXyXoEqAioqBQ8ACeKVN7c0dsML959fmg=;
        b=LQwZEolhmTkPs1xqmyZzKQoACDogKyQew2/5eDi2S7o3hzEmskYDWNJ4VeHnpUXTekoIr3
        cqxKANFvD8GrGcb8HL3GAwpUBFdemJQ/+DdceV+go2uTFju17LF7RjKCYCVgY7EqEH5sWq
        +/P0YBUG8xwlGlVZ3LNsrqmVk6Md93o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-DsRmg8fTPg-yMm0SjjM9NQ-1; Thu, 26 Jan 2023 09:36:32 -0500
X-MC-Unique: DsRmg8fTPg-yMm0SjjM9NQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B5C6857A99;
        Thu, 26 Jan 2023 14:36:31 +0000 (UTC)
Received: from localhost (unknown [10.39.195.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FAB340C2064;
        Thu, 26 Jan 2023 14:36:30 +0000 (UTC)
Date:   Thu, 26 Jan 2023 09:36:28 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, vromanso@redhat.com, kwolf@redhat.com,
        mimehta@redhat.com, acardace@redhat.com
Subject: Re: rbd kernel block driver memory usage
Message-ID: <Y9KP7EX9+Ub/StL/@fedora>
References: <Y9FffDxl2sa9762M@fedora>
 <CAOi1vP8+nQMsGPK-SW-FG4C2HAgp76dEHeTEwQ2xxi2oJLH1aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JRth/DW949aLcw4I"
Content-Disposition: inline
In-Reply-To: <CAOi1vP8+nQMsGPK-SW-FG4C2HAgp76dEHeTEwQ2xxi2oJLH1aA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--JRth/DW949aLcw4I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 26, 2023 at 02:48:27PM +0100, Ilya Dryomov wrote:
> On Wed, Jan 25, 2023 at 5:57 PM Stefan Hajnoczi <stefanha@redhat.com> wro=
te:
> >
> > Hi,
> > What sort of memory usage is expected under heavy I/O to an rbd block
> > device with O_DIRECT?
> >
> > For example:
> > - Page cache: none (O_DIRECT)
> > - Socket snd/rcv buffers: yes
>=20
> Hi Stefan,
>=20
> There is a socket open to each OSD (object storage daemon).  A Ceph
> cluster may have tens, hundreds or even thousands of OSDs (although the
> latter is rare -- usually folks end up with several smaller clusters
> instead a single large cluster).  Under heavy random I/O and given
> a big enough RBD image, it's reasonable to assume that most if not all
> OSDs would be involved and therefore their sessions would be active.
>=20
> A thing to note is that, by default, OSD sessions are shared between
> RBD devices.  So as long as all RBD images that are mapped on a node
> belong to the same cluster, the same set of sockets would be used.
>=20
> Idle OSD sockets get closed after 60 seconds of inactivity.
>=20
>=20
> > - Internal rbd buffers?
> >
> > I am trying to understand how similar Linux rbd block devices behave
> > compared to local block device memory consumption (like NVMe PCI).
>=20
> RBD doesn't do any internal buffering.  Data is read from/written to
> the wire directly to/from BIO pages.  The only exception to that is the
> "secure" mode -- built-in encryption for Ceph on-the-wire protocol.  In
> that case the data is buffered, partly because RBD obviously can't mess
> with plaintext data in the BIO and partly because the Linux kernel
> crypto API isn't flexible enough.
>=20
> There is some memory overhead associated with each I/O (OSD request
> metadata encoding, mostly).  It's surely larger than in the NVMe PCI
> case.  I don't have the exact number but it should be less than 4K per
> I/O in almost all cases.  This memory is coming out of private SLAB
> caches and could be reclaimable had we set SLAB_RECLAIM_ACCOUNT on
> them.

Thanks, this information is very useful. I was trying to get a sense of
whether to look deeper into the rbd driver in a OOM kill scenario.

Stefan

--JRth/DW949aLcw4I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPSj+wACgkQnKSrs4Gr
c8hA5AgAw729ESYh5fmI++NxS93GbJSnKIZC6ePFD1VqjKsEWsX3mE5CNXSteweT
WedUXZmC9uCszIcJ3yFxsYBkF9lsnGA2ncP53q65BckmXFVxSX5CT7TgjbpEtsjQ
CVjIsX9JrTlfOD06cJjbh6xEske9DjcjeIXJXDqV/nhZzglxEzdYoqbWEzDFznCd
IBgFECL4yRAGl2QjB/Md6ruF5VWHYrfvZVPvxkowCeiNHN1A+VoOPR8pzlbDTJ6E
N6XO+hwzeesnoR7ZH7EmF67+TeHF0kYuhmWUBNNDLi+wkUrvifcNk1jNLceyqhHG
cNrJeTJyQdrKtjLWfikcVmxNbB2HVw==
=CoG0
-----END PGP SIGNATURE-----

--JRth/DW949aLcw4I--

