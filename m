Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472AF5B6C7B
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Sep 2022 13:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiIMLng (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Sep 2022 07:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiIMLnd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Sep 2022 07:43:33 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C815C355
        for <ceph-devel@vger.kernel.org>; Tue, 13 Sep 2022 04:43:30 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dv25so26780865ejb.12
        for <ceph-devel@vger.kernel.org>; Tue, 13 Sep 2022 04:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=GlXT8jMi6+YGg4p0LsWa36W2HSGoYNCL2SfHtlwDQmU=;
        b=kQBGLHMeGnXk8Za9GAuZGT4maIhUt9bYV2RWmmT53hDjUPvqJC12uZKIRlm2DMi9b4
         JQZ0pStIe9Z40TOKhTrxr23jRy2ZMR4bvYsqD993zsl5yslpZqakT93SPrADpqWC1l+F
         tpeGZq3s2TQuw88jkBGdYUGlVwchOtWHHUiMl2TuptGQ26KeNgG49KmqBIYVmTo7ka/d
         gJ/FjpHZn+3hTrUJyHvXxQOk7bn1WmOnyOPh5WE5qSTfzRRUsrGx5cRAD0cnpF88YlFT
         yjJZa90Qwn6NoI71QHtubDzNLVZ8KH3WXzIbYQrpjfk+P6x7oyhcRTKfnTMzNU6aWq+W
         SIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=GlXT8jMi6+YGg4p0LsWa36W2HSGoYNCL2SfHtlwDQmU=;
        b=ccmujbCR0Z/wC6bc7U+BfEHq7hztFW0vqNln+8ThZAJo4xUFFogHfO/hYaUXPCXt7U
         6cI8x0WjquKjH1PFVECCjT16C/2o+KR0XN/ZOmjiieQYmmCjmtFGqk6z7aoCSMuvpvsS
         aLAQ2z9Oh2rbPFkylDy36Zk8IsKJAvothxPDw0w0ykfJSPngmgSV/+CWwa6RKHZM7DSP
         /EFBjU/s3HoxjezUo7qxpZyD2hthVSZLddcr3rOMlrDO7sfxkjGrfEcpjNqQwltlrvtO
         HfY+hhjmNBhzKufA8JtlqV6drSgUptktLv+hhgJ5w0WHie0QnV9rgcFeTAZkCEylrrLY
         ShUw==
X-Gm-Message-State: ACgBeo3sycxyR1di/e8p4zfdz51TJPgAe57HUaC97UkImWsyG5rZboDY
        qWrW7+e0/MXHJOuXTX61E6+b42V6ZnESy9pSUhXiyR2ku7E=
X-Google-Smtp-Source: AA6agR4XSCgb6PrxoXt0wtv/FyEtuXbpCNS8XuK1MYVfOSpfRl2ox3kkvv1B5/YBP3VkvPn35HRxVdH8vOxKQbRqTl0=
X-Received: by 2002:a17:907:7b9a:b0:778:adc1:1b0b with SMTP id
 ne26-20020a1709077b9a00b00778adc11b0bmr15758695ejc.569.1663069408671; Tue, 13
 Sep 2022 04:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220913012043.GA568834@onthe.net.au>
In-Reply-To: <20220913012043.GA568834@onthe.net.au>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 13 Sep 2022 13:43:16 +0200
Message-ID: <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
Subject: Re: rbd unmap fails with "Device or resource busy"
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
>
> Hi,
>
> What can make a "rbd unmap" fail, assuming the device is not mounted and not
> (obviously) open by any other processes?
>
> linux-5.15.58
> ceph-16.2.9
>
> I have multiple XFS on rbd filesystems, and often create rbd snapshots, map
> and read-only mount the snapshot, perform some work on the fs, then unmount
> and unmap. The unmap regularly (about 1 in 10 times) fails like:
>
> $ sudo rbd unmap /dev/rbd29
> rbd: sysfs write failed
> rbd: unmap failed: (16) Device or resource busy
>
> I've double checked the device is no longer mounted, and, using "lsof" etc.,
> nothing has the device open.

Hi Chris,

One thing that "lsof" is oblivious to is multipath, see
https://tracker.ceph.com/issues/12763.

>
> A "rbd unmap -f" can unmap the "busy" device but I'm concerned this may have
> undesirable consequences, e.g. ceph resource leakage, or even potential data
> corruption on non-read-only mounts.
>
> I've found that waiting "a while", e.g. 5-30 minutes, will usually allow the
> "busy" device to be unmapped without the -f flag.

"Device or resource busy" error from "rbd unmap" clearly indicates
that the block device is still open by something.  In this case -- you
are mounting a block-level snapshot of an XFS filesystem whose "HEAD"
is already mounted -- perhaps it could be some background XFS worker
thread?  I'm not sure if "nouuid" mount option solves all issues there.

>
> A simple "map/mount/read/unmount/unmap" test sees the unmap fail about 1 in 10
> times. When it fails it often takes 30 min or more for the unmap to finally
> succeed. E.g.:
>
> ----------------------------------------
> #!/bin/bash
>
> set -e
>
> rbdname=pool/name
>
> for ((i=0; ++i<=50; )); do
>    dev=$(rbd map "${rbdname}")
>    mount -oro,norecovery,nouuid "${dev}" /mnt/test
>
>    dd if="/mnt/test/big-file" of=/dev/null bs=1G count=1
>    umount /mnt/test
>    # blockdev --flushbufs "${dev}"
>    for ((j=0; ++j; )); do
>      rbd unmap "${rdev}" && break
>      sleep 5m
>    done
> done
> ----------------------------------------
>
> Running "blockdev --flushbufs" prior to the unmap doesn't change the unmap
> failures.

Yeah, I wouldn't expect that to affect anything there.

Have you encountered this error in other scenarios, i.e. without
mounting snapshots this way or with ext4 instead of XFS?

Thanks,

                Ilya
