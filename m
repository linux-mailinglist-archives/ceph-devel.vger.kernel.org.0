Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6112CA667
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Dec 2020 15:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391762AbgLAO4d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Dec 2020 09:56:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388952AbgLAO4d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Dec 2020 09:56:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606834507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nrYy36PWYz1m0Ryz7ItEpQoD9UqFQY+CGfgBdXzmZbk=;
        b=AHPah1l7+pA1lg64AGuviM5iRxCHa/CK/HJ3nGdx/O9a3Fc0DTHWme2ycx2EhpjaQpgm03
        +4y91xs17Hxs9J+4SFSdL6Hu12fQuypxWpl0mm6ifEOcbd1R7JndHcsO4e9SZiSUDn4U8A
        K5XNrz25C6JKBnJXg5wR8IMVau9+ZUw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-zlcMz8XbOgOm99bdj9lAYg-1; Tue, 01 Dec 2020 09:55:04 -0500
X-MC-Unique: zlcMz8XbOgOm99bdj9lAYg-1
Received: by mail-qk1-f198.google.com with SMTP id s128so1562106qke.0
        for <ceph-devel@vger.kernel.org>; Tue, 01 Dec 2020 06:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=nrYy36PWYz1m0Ryz7ItEpQoD9UqFQY+CGfgBdXzmZbk=;
        b=ez/IlYamG6Ld5T5riZ/mD6cf4GCaiqcDIT96LFa8SSrUTETf/R6Y49p1OT5moHWqHX
         ekFMWCNUoWKbaShjUzCoEYAjnSIvsMEPLLv9M0jsACx7FUqe3FExpJzg8i72DudaYl4M
         J9vyBENfN9WKRK99fynxXSKVC/dZQ7+CO0C9SUlSqCZ9VC5SsAqJaZ/4p2Zz2SpTUKLP
         c5O5NbxPjvjhd9PixCKfznbCiG9HDxmTgr5S2lEZIsPIMshmtPf2KssLLupR9UEa176d
         mKODJoxh5OenLHeBNszqHX0Lw6AbLTLuh1y8Wr7R50u4U8ZDsOv2U7lJvKuM7QrqhAt2
         xv0A==
X-Gm-Message-State: AOAM533Zg1FlVD5p1uGhDH8SPco1px8Sq2yTn7Ix0UWRXka7+ZLXhHNj
        cJXtRgf4NeivDPv6+6Jdgh6tp0hWbdA+zdjmWVoaik+H6os88RlfeDfwdZEl+hobTV7YYkobwo1
        gBlBFlwbpSPKF3jGAFSuYgg==
X-Received: by 2002:a0c:f20f:: with SMTP id h15mr3274446qvk.54.1606834503597;
        Tue, 01 Dec 2020 06:55:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy+uZEIPZoZtmGzQhfocvGx7GDMQi/4WHJ3A3XLr+XufUTVgexo9gUcguP4a89vpDCU56iN/g==
X-Received: by 2002:a0c:f20f:: with SMTP id h15mr3274427qvk.54.1606834503323;
        Tue, 01 Dec 2020 06:55:03 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id n95sm2282946qte.43.2020.12.01.06.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 06:55:02 -0800 (PST)
Message-ID: <36b421ea14b3b14226b3e7c0407876886bb74e08.camel@redhat.com>
Subject: provisioning clients in teuthology with an extra local filesystem
From:   Jeff Layton <jlayton@redhat.com>
To:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>
Cc:     sepia <sepia@ceph.io>, David Galloway <dgallowa@redhat.com>
Date:   Tue, 01 Dec 2020 09:55:02 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've been working on a patch series to overhaul the fscache code in the
kclient. I also have this (really old) tracker to add fscache testing to
teuthology:

    https://tracker.ceph.com/issues/6373

It would be ideal if the clients in such testing had a dedicated
filesystem mounted on /var/cache/fscache, so that if it fills up it
doesn't take down the rootfs with it. We'll also need to have
cachefilesd installed and running in the client hosts.

Is it possible to do this in teuthology? How would I approach this?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

