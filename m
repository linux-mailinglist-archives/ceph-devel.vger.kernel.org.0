Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1463FBC3B
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 00:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfKMXHs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 18:07:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55756 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbfKMXHs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 18:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573686466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Af3xjZVPwpehrlGco9NARZTtS18PCQEkRErtMAq8w7A=;
        b=gTie6wfA7N1RWsH8VTupUwuf4SPSxbMf2cW8qsKG3SpX2gQu4n66u+CiXj8czizpHrpVhF
        xG3GM6d51Wh87C9t87Y5Ai9c5IeyGs8WVNEvtm/GFzRjdFxntQwBD/2hKDNow3hWWeGL+m
        k+AWnxxKdeLJ9EB9/7xfmIeNI1cfbzE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-6SX4GOavNJm6DVqtQUNC4Q-1; Wed, 13 Nov 2019 18:07:44 -0500
Received: by mail-qv1-f69.google.com with SMTP id k11so2738379qvw.19
        for <ceph-devel@vger.kernel.org>; Wed, 13 Nov 2019 15:07:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8FhU5lz6aRNFE3Rz3qqUuOjtHtFgAS4WGcbAQcZD9c=;
        b=QavNHF8GwfQgWbCU7xHGtwnQvmy1afsVuWmGnYojSzyUQpN32pI0Yx9Oq93uSFbBqk
         /e10GiQSTDmBlMGUuPavUvvoiZ//7jS0dI3v0YiJP0jVD5f8Cm9Rm9+4LmEZAxOlDFKU
         +OgJQ5QUkUqh0RlhUEg63chIB45lH0YagskZZabT3d82Pnj1tHLvttNMbgbzJKuQ1+Yd
         EEl5B3cJziH42BYkmynFkIBlw/n5xLF2eijJYtB1SMz9QwDv9Y0O53L8w/MmED586e3q
         x/TRycbYLhtEhv0bSsDmVpTZJcSBVjtfSBa6ZSjXQ+1i4r/NsiwvF+Ho/9yxi4p3T2MS
         Aj4g==
X-Gm-Message-State: APjAAAUXHmA4/Qq7GXOvdIuOmLiwcX8jKBqQfXyTzYNqjvw/rpSGlaQJ
        g+Iby9F1oM2ir5H05A1XpbkQ3U/3lHEM/qdAkewMRXpjWnW28vqHBkhTXMLuwK6EiCw8iJrilE2
        ZlstZn66/+R62JlPIVhF/R44HexR82VVZXBBlvA==
X-Received: by 2002:a37:a00f:: with SMTP id j15mr5069262qke.103.1573686464190;
        Wed, 13 Nov 2019 15:07:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqy/4MBqEgzXQrIKuIY4dFSHudDlt0xeec65oBfW1YTMbAF+6WL4TcJHqyIrK3SXT80bDDZNF51rMUcHsO41xvA=
X-Received: by 2002:a37:a00f:: with SMTP id j15mr5069246qke.103.1573686463948;
 Wed, 13 Nov 2019 15:07:43 -0800 (PST)
MIME-Version: 1.0
References: <CAKQB+ftphk7pepLdGEgckLtfj=KBp02cMqdea+R_NTd6Gwn-TA@mail.gmail.com>
In-Reply-To: <CAKQB+ftphk7pepLdGEgckLtfj=KBp02cMqdea+R_NTd6Gwn-TA@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 13 Nov 2019 15:07:18 -0800
Message-ID: <CA+2bHPaCg4Pq-88hnvnH93QCOfgKv27gDTUjHF5rnDr6Nd2=wQ@mail.gmail.com>
Subject: Re: [ceph-users] Revert a CephFS snapshot?
To:     Jerry Lee <leisurelysw24@gmail.com>
Cc:     Ceph Users <ceph-users@lists.ceph.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
X-MC-Unique: 6SX4GOavNJm6DVqtQUNC4Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Nov 13, 2019 at 2:30 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> Recently, I'm evaluating the snpahsot feature of CephFS from kernel
> client and everthing works like a charm.  But, it seems that reverting
> a snapshot is not available currently.  Is there some reason or
> technical limitation that the feature is not provided?  Any insights
> or ideas are appreciated.

Please provide more information about what you tried to do (commands
run) and how it surprised you.

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

