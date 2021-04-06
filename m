Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FD0354A9F
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Apr 2021 03:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbhDFBwS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Apr 2021 21:52:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238146AbhDFBwS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Apr 2021 21:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617673931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Owngt8/mKke3J0ltXGwcKUuT0YV6gz/ug71lOS/FllI=;
        b=FS9GdLICMJjM+9NxtQd49htnlBqbv7Nk2vTk/wYkBValxEMLgfhVkJAUIms1ApvCtzOh6o
        TFjfynTIsLjg0Xq6xl967tHS0T80LFEkR2x2KrYvdmPNsY5WsvRTD3SG/3kjDx6P9lyRzd
        tM+ozv5NnVVx8MyP2RAUt4KzgSTQWr8=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-ysiS8rgHNwinFdyDjxnahQ-1; Mon, 05 Apr 2021 21:52:08 -0400
X-MC-Unique: ysiS8rgHNwinFdyDjxnahQ-1
Received: by mail-io1-f71.google.com with SMTP id d12so12011248ioo.10
        for <ceph-devel@vger.kernel.org>; Mon, 05 Apr 2021 18:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Owngt8/mKke3J0ltXGwcKUuT0YV6gz/ug71lOS/FllI=;
        b=sMw99AbTZ1Gls1TN8yNu8TgeJ3p87JyHNMba1I2dqN34VxUcVNfGyygCCgpRBAenYX
         t8CFTrdZDOphys/3S9pmHuuqgBttxsSCGqvNRwrE43Yl1qLsUh2o7mInr/jpIGUjj0U/
         5WcJYPHrj2VDUzZfZ876lW5bhPXG1L/aQXXialU0qgkoRXwNfRu6Si6GeG/1MDSAyduB
         L8MVmLCjrAfsPxSZO49WLY7kcETFu2zP/lKpsW8/IqiDJC8ESoouTeaPH5RixmTUuiH6
         KEuPZXoTUPLGsplD8iZim137y3NUpjlpt1Tx9aMZHSU1rxTukZXF3sNLP4AmKqu4+ZET
         S9/Q==
X-Gm-Message-State: AOAM530CZfQ1rp6f/2R9Sn47hMX9kumWXZTtrYmS0W+YJxQY0EVaDBLn
        g/Bk2wSEEBQf8ylftAIyBj/sFnNRnNEbAKdsxzTS9z8l2Y3KEfFiS9rVAL9gwStKev/gIUq6Cj3
        XDT55oT0bsky7ToRlVyBcWGUBMBmM96TQ5JEpAQ==
X-Received: by 2002:a02:6989:: with SMTP id e131mr26833069jac.105.1617673928399;
        Mon, 05 Apr 2021 18:52:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyT/w1FZH+DW1TwZF84IWJrgA1GAknJ1QMV5oETSK/hJlf0/aP7oyhsGz/OgNcRQZbLvxaxq1VqjtRSb4NuReY=
X-Received: by 2002:a02:6989:: with SMTP id e131mr26833059jac.105.1617673928243;
 Mon, 05 Apr 2021 18:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210405113254.8085-1-jlayton@kernel.org>
In-Reply-To: <20210405113254.8085-1-jlayton@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Mon, 5 Apr 2021 18:51:42 -0700
Message-ID: <CA+2bHPZKz_pxsNTR992XOTFpdmTMcDDgohh52QcDfR+_=1T72w@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't allow access to MDS-private inodes
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Zheng Yan <ukernel@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 5, 2021 at 4:33 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> The MDS reserves a set of inodes for its own usage, and these should
> never be accessible to clients. Add a new helper to vet a proposed
> inode number against that range, and complain loudly and refuse to
> create or look it up if it's in it.
>
> Also, ensure that the MDS doesn't try to delegate that range to us
> either. Print a warning if it does, and don't save the range in the
> xarray.
>
> URL: https://tracker.ceph.com/issues/49922
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

