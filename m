Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55ECD18D20F
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Mar 2020 15:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgCTO5p (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Mar 2020 10:57:45 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:34850 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727133AbgCTO5p (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 10:57:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584716264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yHX5tu4L+wafVrGADIIPcvwfpWGpmsK/2PIeQC9t1nM=;
        b=UczvDOAjz0vP9gS2pdrp6W6awuzx+o9gmuRSO+dPHNEKHUA7Z7KkEbDnd1TpqtXbaKAld5
        PJDl3lHVcVRaqRBnfHqijl4Pst/YKnla1/Cm9VrK8e1KmRCLTJ3df9c468Kk1LGW1Be4pW
        /HRWzJVCmxLmStWZsAHnWpDkpjEZD8c=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-swbQNaZWMJuQDPDH6GdoZQ-1; Fri, 20 Mar 2020 10:57:41 -0400
X-MC-Unique: swbQNaZWMJuQDPDH6GdoZQ-1
Received: by mail-qt1-f197.google.com with SMTP id t6so5945359qtj.12
        for <ceph-devel@vger.kernel.org>; Fri, 20 Mar 2020 07:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=yHX5tu4L+wafVrGADIIPcvwfpWGpmsK/2PIeQC9t1nM=;
        b=trx5gOfemle9iLbNrNTtw7xi+P2q5+gZFmxWGgw1qoaOHdg6eBBPEZChpYu7J/5GJT
         u07IjXINN1Vbe26QhBE5iZ0vk4aqvGRWgwz1fSkRQTWM+/iuoClXxchOiyNBjFHoIwrd
         N/CbnU8KjD5qBM9fOvKxmXpewc3/i+SuulJP2UKGZhA/3A1Y3j8VivSS38mYQDJ58rRf
         Z94wdIfK42/a5mEsHh4Kdlxp+iyJ4D8Rzb0SUvUDHb7aUjiAyuNzZVSMnRi7Ic2NLydQ
         kcJHE6TkMTujYmb8BSow9QzIfTq4LwsUjK+hGAcDVtW1IINYTYiPkIqiPUG5UmFH6lhy
         syRA==
X-Gm-Message-State: ANhLgQ0nUqpFxR3fv1IhLnMDMDcvpse7PkZibdKJcewn+uQFXJF85BEE
        yNDYJeRPXfe/0/efPBKHovN+08vULFmDS/YvGmcwnujHJ4GW+Kln4CtOlI5fYLswEBZXzI4AWbc
        r08HVTQrkudMGmA9tWEzNNA==
X-Received: by 2002:a05:6214:a73:: with SMTP id ef19mr8365976qvb.98.1584716260003;
        Fri, 20 Mar 2020 07:57:40 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvCSClv53FTAGmeKM9zfUDYuDJ+lpUrxjGZcWF5ViaRSPoPrxKSe702G0oWRZKFbIrdhiI3bw==
X-Received: by 2002:a05:6214:a73:: with SMTP id ef19mr8365948qvb.98.1584716259736;
        Fri, 20 Mar 2020 07:57:39 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id f185sm1304248qkb.50.2020.03.20.07.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 07:57:39 -0700 (PDT)
Message-ID: <833eb05d54ca8338843566a1fce9afee9283bdb2.camel@redhat.com>
Subject: extend cephadm to do minimal client setup for kcephfs (and maybe
 krbd)?
From:   Jeff Layton <jlayton@redhat.com>
To:     "dev@ceph.io" <dev@ceph.io>,
        Ceph Development <ceph-devel@vger.kernel.org>
Cc:     Sage Weil <sage@newdream.net>
Date:   Fri, 20 Mar 2020 10:57:38 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've had this PR sitting around for a while:

    https://github.com/ceph/ceph/pull/31885

It's bitrotted a bit, and I'll clean that up soon, but after looking
over cephadm, I wonder if it would make sense to also extend it to do
these actions on machines that are just intended to be kcephfs or krbd
clients.

We typically don't need to do a full-blown install on the clients, so
being able to install just the minimum packages needed and do a minimal
conf/keyring setup would be nice.

Does this make sense? I'll open a tracker if the principal cephadm devs
are OK with it.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

