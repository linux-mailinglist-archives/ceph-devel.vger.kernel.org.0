Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EDA29EF95
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Oct 2020 16:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgJ2PTy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Oct 2020 11:19:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727839AbgJ2PTy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 11:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603984793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VF7eMEIX/ir9U9fkle1SX63xKVvAwW8p4VNx3URexWI=;
        b=fzj7rKZc2C9vQP0XS6/GuMolsjCbcCmI4fhKq6RbFZfhfuMfjsIuLIpaAe51G0zWEaWErY
        +ZA7gSzkgFf4A9XeswW7HhjDwWFl7TFdBExv2hVqPlM2Vd2p+MPHNSEXd5nHB2Ejo8PAwn
        uaSYqXdJAa1c8wr3H1iSvGC3U7+/Fec=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-0BiBIPTrPAGz2zxfPhq4kg-1; Thu, 29 Oct 2020 11:19:50 -0400
X-MC-Unique: 0BiBIPTrPAGz2zxfPhq4kg-1
Received: by mail-io1-f71.google.com with SMTP id m25so2094394ioh.18
        for <ceph-devel@vger.kernel.org>; Thu, 29 Oct 2020 08:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=VF7eMEIX/ir9U9fkle1SX63xKVvAwW8p4VNx3URexWI=;
        b=fGzTTw6KUD/aZJ3vk9KEEoV2U8BGe1FZL+ci4NHPfIygUkniTo3jRw1E0WwoASOtIB
         YkMEbnGFJu5QEbuwmjh7YZjq0npouVUMrF2F+vcLTWeOXGEX+1zMs1XtokoaIwbs4+Pu
         JLQIXTBVuEIaris9aGwNQGOmPZffafxXLeCvjCr3ajdhMd5Wd7B9vemGV1EuX4oq1eLr
         WIHNc7rzXsgZnLyGMxd9hdMIFwVEnKicJX6Unh/vbDoaXuUTJVpfjx/kjrmy8tehO0T8
         xQ/4q3L53AwvDZAHW6ZH6w150CQZApyDfsoQL4AkZuehk/V/2b05BQU0d7EtaZ+rhROr
         kLKw==
X-Gm-Message-State: AOAM532UhAFAbEEHzmVGu8ewLJA1lm2oX+bwgSOdtsYWrHqHfsohvzuV
        ZgVfeNbmPHF3ci8RtA/fkgtG2MH43t8hjz3f5yOzjhKXGD4XSz38an3Y/A95bWRBs7U4vH9K99Z
        G+95g1TYCvOtlkJ8r9dISxQ==
X-Received: by 2002:a05:6638:2603:: with SMTP id m3mr3914550jat.43.1603984788488;
        Thu, 29 Oct 2020 08:19:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGzDQOthCHmcDJvaMsPxAlkBt2QDf8lomUVilOiftc/sJszJ1N7JWjQ+GGpGw6FdMKTR07mA==
X-Received: by 2002:a05:6638:2603:: with SMTP id m3mr3914539jat.43.1603984788318;
        Thu, 29 Oct 2020 08:19:48 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id v88sm2665135ila.71.2020.10.29.08.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 08:19:47 -0700 (PDT)
Message-ID: <b4726535239f4b0e723d3f45da3a7fcf1412c943.camel@redhat.com>
Subject: cephfs inode size handling and inode_drop field in struct
 MetaRequest
From:   Jeff Layton <jlayton@redhat.com>
To:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 29 Oct 2020 11:19:45 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I'm working on a F_SETLEASE implementation for kcephfs, and am hitting a
deadlock of sorts, due to a truncate triggering a cap revoke at an
inopportune time.

The issue is that truncates to a smaller size are always done via 
synchronous call to the MDS, whereas a truncate larger does not if Fx
caps are held. That synchronous call causes the MDS to issue the client
a cap revoke for caps that the lease holds references on (Frw, in
particular). 

The client code has been this way since the inception and I haven't been
able to locate any rationale for it. Some questions about this:

1) Why doesn't the client ever buffer a truncate to smaller size? It
seems like that is something that could be done without a synchronous
MDS call if we hold Fx caps.

2) The client setattr implementations set inode_drop values in the
MetaRequest, but as far as I can tell, those values end up being ignored
by the MDS. What purpose does inode_drop actually serve? Is this field
vestigial?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

