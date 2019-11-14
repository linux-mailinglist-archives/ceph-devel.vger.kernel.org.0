Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B5DFC768
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 14:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfKNN2M (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 08:28:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32144 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfKNN2M (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Nov 2019 08:28:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573738090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QzdbNnBC9/9wq0C3NeYsIo/sTrXtzOJ7ryh6Ik4Bl/o=;
        b=XWz5KU+wuQZfaUth/SxgMil3lm0jBvlkot8+Brh78cYdwpw39jQuC3HYsQOhx4kOlCbBom
        ph8oQp7zqiA2IVQpsq+OBgWjgosBgQ3/w8JDzkU6GvL5GPxXOf7cUCiF9c0V9wzKRA6e15
        EteOxUy+roQdrxROK4GU5EedqvNTqws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-m4ECI2X_PzWJ7toHTwKyDg-1; Thu, 14 Nov 2019 08:28:09 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19393107ACCC;
        Thu, 14 Nov 2019 13:28:08 +0000 (UTC)
Received: from ovpn-112-22.phx2.redhat.com (ovpn-112-22.phx2.redhat.com [10.3.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CAFCA10375DC;
        Thu, 14 Nov 2019 13:28:06 +0000 (UTC)
Date:   Thu, 14 Nov 2019 13:28:05 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     Jeff Layton <jlayton@kernel.org>, gfarnum@redhat.com
cc:     Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] ceph: safely use 'copy-from' Op on Octopus
 OSDs
In-Reply-To: <cbda3a69d25b04e10332e7b3898064a93b2d04ae.camel@kernel.org>
Message-ID: <alpine.DEB.2.21.1911141326260.17979@piezo.novalocal>
References: <20191114105736.8636-1-lhenriques@suse.com> <cbda3a69d25b04e10332e7b3898064a93b2d04ae.camel@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: m4ECI2X_PzWJ7toHTwKyDg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 14 Nov 2019, Jeff Layton wrote:
> On Thu, 2019-11-14 at 10:57 +0000, Luis Henriques wrote:
> > Hi!
> >=20
> > So, after the feedback I got from v1 [1] I've sent out a pull-request
> > for the OSDs [2] which encodes require_osd_release into the OSDMap
> > client data.  This allows the client to figure out which ceph release
> > the OSDs cluster is running and decide whether or not it's safe to use
> > the copy-from Op for copy_file_range.
> >=20
> > This new patchset I'm sending simply adds enough functionality to the
> > kernel client so that it can take advantage of this OSD patch:
> >=20
> > 0001 - adds the ability to decode TYPE_MSGR2 addresses.  This is a
> >        required functionality for enabling SERVER_NAUTILUS in the
> >        client.  I hope I got the new format right, as I couldn't figure
> >        out what the hard-coded values (see comments) really mean.
> >=20
>=20
> nit: the first 3 patch subject lines should probably be prefixed with
> "libceph:"
>=20
> > 0002 - allows the client to retrieve the new require_osd_release field
> >        from the OSDMap if available.  This patch also adds SERVER_MIMIC=
,
> >        SERVER_NAUTILUS and SERVER_OCTOPUS to the supported features,
> >        which TBH I'm not sure if that's a safe thing to do -- the only
> >        issue I've seen was that Nautilus requires the ability to decode
> >        TYPE_MSGR2 address, but I may have missed others.
> >=20
>=20
> Yes, this needs to be done with care. We have to ensure that the server
> side isn't assuming that the client supports something that it doesn't.
> I think that means just trawling through the code and verifying whether
> this is safe.
>=20
> > 0003 - debug code to add require_osd_release to the osdmap debugfs file=
.
> >=20
> > 0004 - adds the truncate_{seq,size} fields to the 'copy-from' operation
> >        if the OSDs are >=3D Octopus.
> >=20
> > Also note that, as suggested by Ilya, I've dropped the patch that would
> > change the default mount options to 'copyfrom'.
> >=20
> > These patches have been tested with the xfstests generic test suite, an=
d
> > with a couple of other (local) tests that exercise the cephfs
> > copy_file_range syscall.  I didn't saw any issues, but as I said above,
> > I'm not really sure if adding the SERVER_* flags to the supported
> > features have other side effects.
> >=20
> > [1] https://lore.kernel.org/lkml/20191108141555.31176-1-lhenriques@suse=
.com/
> > [2] https://github.com/ceph/ceph/pull/31611
> >=20
>=20
> I'm just getting caught up on the discussion here, but why was it
> decided to do it this way instead of just adding a new OSD
> "copy-from-no-truncseq" operation? Once you tried it once and an OSD
> didn't support it, you could just give up on using it any longer? That
> seems a lot simpler than trying to monkey with feature bits.

I don't remember the original discussion either, but in retrospect that=20
does seem much simpler--especially since hte client is conditioning=20
sending this based on the the require_osd_release.  It seems like passing=
=20
a flag to the copy-from op would be more reasonable instead of conditional=
=20
feature-based behavior.

Greg, do you remember why we ended up here?

sage

