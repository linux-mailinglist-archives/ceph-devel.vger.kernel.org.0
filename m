Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4E510AE35
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2019 11:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfK0Kud (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Nov 2019 05:50:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27367 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726204AbfK0Kud (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Nov 2019 05:50:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574851832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=84flo3QNTb8v4p6mfHiWlR5Km/YjdFviUNjT7zK+RsY=;
        b=aYUaCAcdTji7uN4Bnl9EKfiNpnFr3c3rs1eA2n0CyEMZhiPoUzSZ05VaGUu9OZolV//j0i
        h+jGrNvC7f0K7FfCgfMzW/+tBGzbqQcdgR/v9UF7f+ATuEY8v4SWIQ1IMmJClaOWkpKbCX
        z0gvVilMjYJwzMDd0HYYhZpNjVogK2s=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-iYczEqv5OsOr4SVvA_rScQ-1; Wed, 27 Nov 2019 05:50:30 -0500
Received: by mail-yb1-f200.google.com with SMTP id u39so15220397ybi.18
        for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2019 02:50:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=84flo3QNTb8v4p6mfHiWlR5Km/YjdFviUNjT7zK+RsY=;
        b=jMtbiQn4EwMYANyDvqHY+huOcMMn2St4E4N3OMOJa/8QxqiXyQ892ibZPPgntNvY3X
         OpYayZvzN/GpLTGmUDH0QL6sCcyY9imF6EMZHkx3ZZyXzM6+c0FyV6gkVM85YiQ9kXmz
         S4qBJZGqAYqHPzjnN3Ga8cR6P+rTme/tgKQW5TgXdxWKxvUgtacjjE9Ql/yWhhtM11On
         CmSQyXph8t9TU98S93jHJOiN/ekCG5EDcMri5+iLRFDovUVK+DRxrDkCp/oeCDHg0qTw
         mILrNknY9z10w7Mln01wNP/aURBNb/dOtsdbT3IfC2NcDkvGuIu3j7TK8cgL3SX7Spd8
         2YVQ==
X-Gm-Message-State: APjAAAVqcbeBiJ/VM2muEz3BEDY1OTu9UsNj8liPuXlrGb2/4AiloLnS
        zPcrsz4ksC+H2N0fR393bS+p7S1BaQhoqWwZqC6O0s4wonTKbNpUuzuYC6q2Q5z78PgZcFgF9HP
        qg8h1XOHrd2tqzpf28sYa6A==
X-Received: by 2002:a0d:e808:: with SMTP id r8mr2243638ywe.275.1574851830416;
        Wed, 27 Nov 2019 02:50:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6m9BJraQ1kxRLfPu7Sk5wFo7OYuetlTUo+hQ/UJzQjoTn9/ASC23MrXuVUDbi5yM9jqc0cA==
X-Received: by 2002:a0d:e808:: with SMTP id r8mr2243622ywe.275.1574851830134;
        Wed, 27 Nov 2019 02:50:30 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id j67sm6456565ywf.71.2019.11.27.02.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 02:50:29 -0800 (PST)
Message-ID: <c1cee0022b074747537d59216ee831b3ea8a3d05.camel@redhat.com>
Subject: Re: cephfs worm feature
From:   Jeff Layton <jlayton@redhat.com>
To:     j j <jiang4357291@gmail.com>, dev@ceph.io
Cc:     ceph-users@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Date:   Wed, 27 Nov 2019 05:50:28 -0500
In-Reply-To: <CABvhRYgc19BtZAe=XFgxtd0VmHjZX9CO2JfqDkw0A7mv8Jxgfw@mail.gmail.com>
References: <CABvhRYgc19BtZAe=XFgxtd0VmHjZX9CO2JfqDkw0A7mv8Jxgfw@mail.gmail.com>
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31)
MIME-Version: 1.0
X-MC-Unique: iYczEqv5OsOr4SVvA_rScQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-11-27 at 15:14 +0800, j j wrote:
> Hi all,
> 
>    Recently I encountered a situation requires reliable file storage with cephfs, and the point is those data is not allowed to get modified or deleted.
> After some learning I found that the WORM(write once read many) feature is exactly what I need.Unfortunately, as far as I know, there is no worm 
> feature in cephfs.
>    So I was wondering is there any plan or design about this feature?
> 
> Thanks.

There's a pull request for this that has been stalled since spring:

    https://github.com/ceph/ceph/pull/26691

Personally, I don't see how we can get away with making file data 100%
immutable. We'll need to allow _some_ entity to un-WORM the thing, and
it was never clear to me how that would work.
-- 
Jeff Layton <jlayton@redhat.com>

