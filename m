Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142E1A02B1
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2019 15:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfH1NJl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Aug 2019 09:09:41 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45652 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfH1NJk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Aug 2019 09:09:40 -0400
Received: by mail-lf1-f68.google.com with SMTP id o11so2080791lfb.12
        for <ceph-devel@vger.kernel.org>; Wed, 28 Aug 2019 06:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N0thGw/URf9/hrIsdMCRXfWA8x/jqqcNYpAteFAyQ40=;
        b=oACxmuHVywUv2JSbJbJfDzqO0HdS8Kk02y0vjoUCtaiVdS//3QidBK1OmiJl7oZs6H
         6YOi0TR71lVK48nq118TCIRv+xHthVztGmrrESSkcB0ZM9hg0SnOLoAOrBGJZIuKrt4s
         /Gi5SVKO9l+c/7MmuFTLp2u8CbNoyLmiwR24tHJlhJPSwFFt3HC0hnVl497Qmpet7ARo
         Hnt3bKiwfVwWYQl3ceEtSCxM6kHvYiiW1K25PNhhjHxHOKQBh1l4fZPc1yrmMf7FZZSV
         Sk8ZS2pdWRDkUahtAwCeWIItH+W6R6kTyVgglTIU+GGurRNtdqHjuUtu8n4Q0cvnldqO
         fFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N0thGw/URf9/hrIsdMCRXfWA8x/jqqcNYpAteFAyQ40=;
        b=aUXblFM0+JpMFJnNbbrqdowUdi8yiW4l9zJeJ/eD7nKBrYrdy1E6ya7Y++48aUo2Ye
         In0cHzjVRw611kEtGeSigV4A/+ODeZDUNVHXGoaRrx85AlpQl2PAs4gdWxXjpttv3+C+
         PwEjRXSvaXcqPObxIeNjZ/cVr6RZ8QTV62Yor7IaMnZu9KA+Zw9JkQzoofVlIbRMYFoT
         3lLHrhZ5KGC7UhUyE2HBMd3JwglcuUogDFGYslh/6hQVhnjDpBa8bR6XDv8HhvFRCXOb
         phXb28l3d8AU/xqZz09k39d/xwR0Bbp6oS9gm5i9y5yFPot3OdIXnQOl2Xui3Rv9jjgR
         2Yfg==
X-Gm-Message-State: APjAAAV8oFz5rp2r6KeEyfdZqEOUgJ/3rzni/dCD7T4ZpT/r6RZirXtX
        DywaKG16poYuw9nsc4NVT6c6rqlXmUm8WI0uDToEw6ff
X-Google-Smtp-Source: APXvYqyyfn6MHxSwt08IbacyAb4I3iwCzOorEjcUDVaGmvZYyj6XNeSE8GlyhYPsMhg3rmsV91nlcNbM0Mkm7i8vGxw=
X-Received: by 2002:a19:f51a:: with SMTP id j26mr2573916lfb.147.1566997778658;
 Wed, 28 Aug 2019 06:09:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190828094855.49918-1-chenerqi@gmail.com> <c568f3b8453a55516dd13bfd617edb778a6f7b1c.camel@kernel.org>
 <CAAM7YAkNmkMhuqU-xjNhBd5dx0RcjxKh4WHXkdazFn2t0BP7Zg@mail.gmail.com>
In-Reply-To: <CAAM7YAkNmkMhuqU-xjNhBd5dx0RcjxKh4WHXkdazFn2t0BP7Zg@mail.gmail.com>
From:   erqi chen <chenerqi@gmail.com>
Date:   Wed, 28 Aug 2019 21:09:27 +0800
Message-ID: <CA+eEYqV=+bixzMwCVMq50wo6UX6YE9T45L_g=EqKVhuLdsw-yg@mail.gmail.com>
Subject: Re: [PATCH] ceph: reconnect connection if session hang in opening state
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

So in this case, the client got blacklisted after sending the request
but before the reply? Ok.
>>
Blacklist is disabled in my env, client fails to response caps revoke,
mds tick evicts it, and before evict closed the session, it cost much
time to remove client caps which is running in finish thread, the next
mds tick comes, I suspect if the client with STATE_KILLING session is
put to to_evict list again,  it happens to kill client's session when
the client opening new session.

I would like to propose a new patch as follow change:
-               if (s->s_state < CEPH_MDS_SESSION_OPEN) {
+               if (s->s_state == CEPH_MDS_SESSION_NEW ||
+                   s->s_state == CEPH_MDS_SESSION_RESTARTING ||
+                   s->s_state == CEPH_MDS_SESSION_REJECTED)
