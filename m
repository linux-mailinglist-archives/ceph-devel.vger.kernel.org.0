Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B6C654449
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Dec 2022 16:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiLVP05 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Dec 2022 10:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiLVP0f (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 22 Dec 2022 10:26:35 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C484C30565
        for <ceph-devel@vger.kernel.org>; Thu, 22 Dec 2022 07:25:52 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id 3so1119027iou.12
        for <ceph-devel@vger.kernel.org>; Thu, 22 Dec 2022 07:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9raFcpnVlE2XUgV1j13OXzhOI6LW5gn6LlHeF9plu4E=;
        b=Nz0QEn/o7mSqcJJ/IB4hxcEZ1qic6w04DYHaScMnH1+8tuUF12OBleEsGAxpPmf3xm
         Kt4fqLX+aqKGDiBeFGOP3dGxsGpnkWe6rUhLGJru08ubca2C4H9K7GzCrDHPan+mI0sp
         dwsJIu0pV4gWuNJ9W0VtpXhmLQ7wlHy3dM+5AI5RLboOpNZ3KKIhquOAA3AJd7yaBnTw
         ALQO5yKmWl/CN4WHedD0RyA6VQyf7WK/iz/K0BCOO6eR/xUC7ePi5VbqzjQ6g3vUiK1N
         Fg5K+WdYRPV0AjwqcJO35Ns4FurNWDLTQTQx3PfniPA7qB61gC28823rWgYR7jNd2RkD
         v6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9raFcpnVlE2XUgV1j13OXzhOI6LW5gn6LlHeF9plu4E=;
        b=VWgf94FEAx+rndRZ+UtRNrMdmDubA5yBtPOZwuTNOtwJVPLArgTx3jmHKWIDcgl7hC
         nc7+h7207FfUBFeRc4TcMrD2OfDvSIlsAjJq6JOzJjv4uLlgAEM99LsuAn28H/fEOSrw
         rjSTlBPXNFxCtXBp7mC7nwaHYu3Emwvy/YpNcb5EyGJX/dNUfOuYj1GN9TQnNa1y3ciy
         6aaRK955nWTpDZGOURcC68CP0l2u6DOhx04nPCE2KA+V+bthswbjZxjc7lfk0q4vy6ZN
         U1sPIRcHdmA6uI//XkYBnVUBkm4q+l74O4LCxvz651aq4kDkWK6Kbj1Vk7Yoza0pEiO+
         X3ww==
X-Gm-Message-State: AFqh2koQh9b/lQK3uI2Tt5n+AnRAAT15Mq4kTUpITF9bV6LQLtufcfqv
        02RSCfPlnvSy9UsLxUUK80gdwcrsoPur5kLmJ+E=
X-Google-Smtp-Source: AMrXdXsEvpSW0qghKufims0bJmho3BEEaRsNXi0wFgEpzwDFxCuFh00mAZLfTqonZWaB7PmU0FTaDLKY6xlEmit8QF8=
X-Received: by 2002:a05:6638:40a3:b0:395:ce15:59bc with SMTP id
 m35-20020a05663840a300b00395ce1559bcmr478468jam.71.1671722752216; Thu, 22 Dec
 2022 07:25:52 -0800 (PST)
MIME-Version: 1.0
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
 <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
 <4c039a76-b638-98b7-1104-e81857df8bcd@redhat.com> <9b714315c8934da38449eb2ce5b85cfc@mpinat.mpg.de>
 <70e8a12c-d94e-7784-c842-cbdd87ff438e@redhat.com> <62582bb6b2124f1a9dd111f29049b25b@mpinat.mpg.de>
 <a6091b92-c216-e525-0bc7-5515225f6dc8@molgen.mpg.de> <a212e2465caf4c7da3aa1fe0e094831f@mpinat.mpg.de>
 <CAOi1vP-g2no3i91SshzcWb8XY6aup4h_GcO6Le=caM8-XmXGnQ@mail.gmail.com> <f3e2a67f41bb49bc8e131ce2f0bf5816@mpinat.mpg.de>
In-Reply-To: <f3e2a67f41bb49bc8e131ce2f0bf5816@mpinat.mpg.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 22 Dec 2022 16:25:39 +0100
Message-ID: <CAOi1vP8G2UgBXvNVv4hjaMcAsjSDC-KBeRpXYhsdTaYcnF0c2Q@mail.gmail.com>
Subject: Re: PROBLEM: CephFS write performance drops by 90%
To:     "Roose, Marco" <marco.roose@mpinat.mpg.de>
Cc:     "Menzel, Paul" <pmenzel@molgen.mpg.de>,
        Xiubo Li <xiubli@redhat.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 22, 2022 at 3:41 PM Roose, Marco <marco.roose@mpinat.mpg.de> wrote:
>
> Hi Ilya,
> thanks for providing the revert. Using that commit all is fine:
>
> ~# uname -a
> Linux S1020-CephTest 6.1.0+ #1 SMP PREEMPT_DYNAMIC Thu Dec 22 14:30:22 CET
> 2022 x86_64 x86_64 x86_64 GNU/Linux
>
> ~# rsync -ah --progress /root/test-file_1000MB /mnt/ceph/test-file_1000MB
> sending incremental file list
> test-file_1000MB
>           1.00G 100%   90.53MB/s    0:00:10 (xfr#1, to-chk=0/1)
>
> I attach some ceph reports taking before, during and after an rsync on a bad
> kernel (5.6.0) for debugging.

I see two CephFS data pools and one of them is nearfull:

    "pool": 10,
    "pool_name": "cephfs_data",
    "create_time": "2020-11-22T08:19:53.701636+0100",
    "flags": 1,
    "flags_names": "hashpspool",

    "pool": 11,
    "pool_name": "cephfs_data_ec",
    "create_time": "2020-11-22T08:22:01.779715+0100",
    "flags": 2053,
    "flags_names": "hashpspool,ec_overwrites,nearfull",

How is this CephFS filesystem is configured?  If you end up writing to
cephfs_data_ec pool there, the slowness is expected.  nearfull makes
the client revert to synchronous writes so that it can properly return
ENOSPC error when nearfull develops into full.  That is the whole point
of the commit that you landed upon when bisecting so of course
reverting it helps:

-   if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
+   if ((map_flags & CEPH_OSDMAP_NEARFULL) ||
+       (pool_flags & CEPH_POOL_FLAG_NEARFULL))
            iocb->ki_flags |= IOCB_DSYNC;

Thanks,

                Ilya
