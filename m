Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D8EFC8A5
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 15:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKNOSC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 09:18:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43056 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727132AbfKNOSC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Nov 2019 09:18:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573741080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UgJy6SxLsqvhT1eq7XHYrbyc/XE4ntEQQsPOh9HtOQY=;
        b=BpAvIlAeBRtVvL+toFag4zbRIgyuhY6Im3hMZWr5DTyAwCR00Ip2pmvRZFmimcVOVvsPJj
        UcYxKhBtS5IwKce8GPUmqK5Ip+tX43BfjygJTQESZiLC4MZFKXyLAktsvVOo2X0/0WFbz6
        vmI6OUMjJ+FuQ0Dd2VOgyfQb4TkOxHU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-fsoAokqzMtq_APCNNcCn3A-1; Thu, 14 Nov 2019 09:17:58 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D54ADBCD;
        Thu, 14 Nov 2019 14:17:57 +0000 (UTC)
Received: from ovpn-112-22.phx2.redhat.com (ovpn-112-22.phx2.redhat.com [10.3.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 803CB75E51;
        Thu, 14 Nov 2019 14:17:46 +0000 (UTC)
Date:   Thu, 14 Nov 2019 14:17:44 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     Ilya Dryomov <idryomov@gmail.com>
cc:     Jeff Layton <jlayton@kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>,
        Luis Henriques <lhenriques@suse.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/4] ceph: safely use 'copy-from' Op on Octopus
 OSDs
In-Reply-To: <CAOi1vP9XaeJdqV-jMP3BM=mjHKqJW8-ynAjCi0xcDD3DtL94KQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1911141416040.17979@piezo.novalocal>
References: <20191114105736.8636-1-lhenriques@suse.com> <cbda3a69d25b04e10332e7b3898064a93b2d04ae.camel@kernel.org> <alpine.DEB.2.21.1911141326260.17979@piezo.novalocal> <CAOi1vP9XaeJdqV-jMP3BM=mjHKqJW8-ynAjCi0xcDD3DtL94KQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: fsoAokqzMtq_APCNNcCn3A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 14 Nov 2019, Ilya Dryomov wrote:
> > > I'm just getting caught up on the discussion here, but why was it
> > > decided to do it this way instead of just adding a new OSD
> > > "copy-from-no-truncseq" operation? Once you tried it once and an OSD
> > > didn't support it, you could just give up on using it any longer? Tha=
t
> > > seems a lot simpler than trying to monkey with feature bits.
> >
> > I don't remember the original discussion either, but in retrospect that
> > does seem much simpler--especially since hte client is conditioning
> > sending this based on the the require_osd_release.  It seems like passi=
ng
> > a flag to the copy-from op would be more reasonable instead of conditio=
nal
> > feature-based behavior.
>=20
> Yeah, I suggested adding require_osd_release to the client portion just
> because we are running into it more and more: Objecter relies on it for
> RESEND_ON_SPLIT for example.  It needs to be accessible so that patches
> like that can be carried over to the kernel client without workarounds.
>=20
> copy-from in its existing form is another example.  AFAIU the problem
> is that copy-from op doesn't reject unknown flags.  Luis added a flag
> in https://github.com/ceph/ceph/pull/25374, but it is simply ignored on
> nautilus and older releases, potentially leading to data corruption.
>=20
> Adding a new op that would be an alias for CEPH_OSD_OP_COPY_FROM with
> CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ like Jeff is suggesting, or a new
> copy-from2 op that would behave just like copy-from, but reject unknown
> flags to avoid similar compatibility issues in the future is probably
> the best thing we can do from the client perspective.

Yeah, I think copy-from2 is the best path.  I think that means we should=20
revert what we merged to ceph.git a few weeks back, Luis!  Sorry we didn't=
=20
put all the pieces together before...

sage

