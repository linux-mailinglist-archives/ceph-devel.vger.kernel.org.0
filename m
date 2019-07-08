Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4780D62CC8
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jul 2019 01:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfGHXxC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Jul 2019 19:53:02 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:45100 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfGHXxC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Jul 2019 19:53:02 -0400
Received: by mail-qk1-f181.google.com with SMTP id s22so14680781qkj.12
        for <ceph-devel@vger.kernel.org>; Mon, 08 Jul 2019 16:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=plhBw2lqVBdLdf/az7zbVw/GcAnMOSTnGqKM5eHiNdE=;
        b=oSGPlTjLgmn9sftaIszSFAw1niGVWbO0d50RmNERAYCeCzV2RMDxsl0Td3U5z6EXDZ
         VBlRULQVYpbSCRNpLXUYgEjowMQc9ns2wZQVF6ZQhaeUCZVpkwWqnRIQbLfYP461s6Fc
         9v8umDs0f6WPOh9Z1uHXbKO5Pl0M4ITLdreqmjMZsmcjq05yk0/RvrYMHQH+Qm4YTdbX
         jtkM9ITYuBMZag5stqDcw0HnKDoI/a/oGsXDu5iMualD72AQp1kUkffMw9NaT/xDCTYO
         fn1ysEhWF9rY0DwM7JNer8WJgywmoy9wKqS98j+9tNn+pq8amAQ1e8Z9Sp6mp2bwAWlh
         AdMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=plhBw2lqVBdLdf/az7zbVw/GcAnMOSTnGqKM5eHiNdE=;
        b=ePjuffj3Tu4MXa4WleVtp/gCmD42h/fL+5tWLoS6CWGUaQ6FOF3HEhqyOVrTbkh5Oy
         LwRJkI0KrtF+EdSxpZWi+K15GrZS0bqViBdVJXC3xZISFJzhYrNQVE9jtEQbA14IPUCc
         DQd2rrgT1OlAKNjYEegWdbc3Ps91+Pi3K8HM3g2PfjsvDZHsXdeEa+n74i/TCTbuSmWx
         OzK5mwKs4gaFeMttvkeJ61VnBXRUl6/VsjJKoybuc2erHE3adyn672brj7Yj5VmYZl4z
         Xg5iK7CgE8HeVG1Owh3UoWreD11eHOBtcurHrn7qn27j3QnIb+8iGrQRconeHYZpjdx+
         90Uw==
X-Gm-Message-State: APjAAAU9wHiLUYJTV9pajjbr5k8z8MF/FyBEEhOzXesSzZ9XryP0HMeC
        2TNJWMjdJehUO9aRlxLzLJ8iMbbjPAhEzetQDes=
X-Google-Smtp-Source: APXvYqxtI3ZMHLgytgmGwrxHZ2ft9d4YkoA9mS43YntkN5inRsW5o5twnHxTUD29AYhvJgMk2N0dde69c4OKeJd8jnA=
X-Received: by 2002:a05:620a:102d:: with SMTP id a13mr15983271qkk.268.1562629981582;
 Mon, 08 Jul 2019 16:53:01 -0700 (PDT)
MIME-Version: 1.0
References: <f93a412ecd6b17389622ac7d0ae9b225921e4163.camel@redhat.com>
In-Reply-To: <f93a412ecd6b17389622ac7d0ae9b225921e4163.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 9 Jul 2019 07:52:50 +0800
Message-ID: <CAAM7YA=DW5jYtWkz-gqZ_Eg8ko-sK8mChMGB7yOV=Xz8o=AhLQ@mail.gmail.com>
Subject: Re: ceph_fsync race with reconnect?
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@newdream.net>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 9, 2019 at 3:23 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> I've been working on a patchset to add inline write support to kcephfs,
> and have run across a potential race in fsync. I could use someone to
> sanity check me though since I don't have a great grasp of the MDS
> session handling:
>
> ceph_fsync() calls try_flush_caps() to flush the dirty metadata back to
> the MDS when Fw caps are flushed back.  try_flush_caps does this,
> however:
>
>                 if (cap->session->s_state < CEPH_MDS_SESSION_OPEN) {
>                         spin_unlock(&ci->i_ceph_lock);
>                         goto out;
>                 }
>

enum {
        CEPH_MDS_SESSION_NEW = 1,
        CEPH_MDS_SESSION_OPENING = 2,
        CEPH_MDS_SESSION_OPEN = 3,
        CEPH_MDS_SESSION_HUNG = 4,
        CEPH_MDS_SESSION_RESTARTING = 5,
        CEPH_MDS_SESSION_RECONNECTING = 6,
        CEPH_MDS_SESSION_CLOSING = 7,
        CEPH_MDS_SESSION_REJECTED = 8,
};

the value of reconnect state is larger than 2


> ...at that point, try_flush_caps will return 0, and set *ptid to 0 on
> the way out. ceph_fsync won't see that Fw is still dirty at that point
> and won't wait, returning without flushing metadata.
>
> Am I missing something that prevents this? I can open a tracker bug for
> this if it is a problem, but I wanted to be sure it was a bug before I
> did so.
>
> Thanks,
> --
> Jeff Layton <jlayton@redhat.com>
>
