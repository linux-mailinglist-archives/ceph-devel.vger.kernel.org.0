Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 471815678E
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 13:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfFZL0k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jun 2019 07:26:40 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42266 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbfFZL0k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jun 2019 07:26:40 -0400
Received: by mail-yw1-f65.google.com with SMTP id s5so975473ywd.9
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jun 2019 04:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KHFytg747JkFq6clGmR7aJK1huz8uziX9oTGDlDLd/M=;
        b=GtEZv4BMqThbrTswfzheXobmxHLM3oY/xxjxr6Ec5W4Keuo90lh/4f7MHA6WhsDjSR
         jEzmWygWxNs6yIQoSSYLym/DMNmT8sEJ12AdZVbdJ26D//SI7GH3qLPx3NVNQ3oOusGv
         Lr0Xo8Z/Ijn2klAYiiWE2C3tSUkSLo5FBFbi62w0h2gfILdYiTEs4w4XSVZcv8YIXVzH
         TsRlxWdxor4yGepKFsC8L8uSH7bRWAtfHssT3Am2v4Zkthi0/OKZOO98yEvI1hinzo93
         1lsKCtUFiZTivh613YO9dOCgigQDCs0h1qNxdN9q6IlUSV2NrTr74U+FbDtAgn4Tlx14
         UtuA==
X-Gm-Message-State: APjAAAV0U9L5RQvIul9u6KiBqZVhe7QbyehWX2kCWgIGg8OkKZrXUDhx
        fsioPFsnnbuSOm0KUmoxhjelIA==
X-Google-Smtp-Source: APXvYqxhNEP2EQRhWOcNJVBd0njCM2XIvztZ9nrzePl5N9fpyvC7scQXuQ0tidm25VUsOi+aqwO1+g==
X-Received: by 2002:a81:3bd4:: with SMTP id i203mr2410395ywa.116.1561548399345;
        Wed, 26 Jun 2019 04:26:39 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-C58.dyn6.twc.com. [2606:a000:1100:37d::c58])
        by smtp.gmail.com with ESMTPSA id 200sm4468605ywq.102.2019.06.26.04.26.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 04:26:38 -0700 (PDT)
Message-ID: <b6056c07d6bfaeee50924d8845504f88e4477c50.camel@redhat.com>
Subject: Re: New CephFS kernel client maintainer
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Wed, 26 Jun 2019 07:26:36 -0400
In-Reply-To: <23249968-661b-2d50-9261-8bcd114d7984@redhat.com>
References: <23249968-661b-2d50-9261-8bcd114d7984@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-05-30 at 22:07 +0800, Yan, Zheng wrote:
> Hello everyone.
> 
> I'd like to introduce new CephFS kernel client maintainer Jeff Layton 
> <jlayton@redhat.com>. Jeff is a long time Linux kernel developer 
> specializing in network file systems. He has worked on CephFS for three 
> years. He also has made significant contributions to the kernel's NFS 
> client and server, the CIFS client and the kernel's VFS layer.
> 
> I will continue to work on CephFS, but spend more time on improving 
> CephFS metadata server.

Sorry for taking so long to respond and thanks for the intro. You leave
some big shoes to fill!

I've finally gotten around to sending a patch for the MAINTAINERS file.
I'm assuming (for now) that you don't want to stay on as co-maintainer.
Let me know if that's incorrect and I'll fix up the patch.

Cheers,
-- 
Jeff Layton <jlayton@redhat.com>

