Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221EB29F247
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Oct 2020 17:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgJ2QyA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Oct 2020 12:54:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgJ2QyA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 12:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603990438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7W3wrnJmrQCtzqZeZogCt+ocDUvuf2s4mP6AAkeh2c=;
        b=gvC1lxTQi97E5rkEyxBHVx9pYWX+h3l+Opvo9xlduR/RgkcPk0OJ4qox049xT0UaFZ46Ox
        DhwJ1IYsWiYWrcDQzobc5+/9CIWc8LFQph7Vad5Ut30jndwsEE+LQbmkoQMiHyRLh5lFxW
        3T84nZpDAma2VgnDSXcGvIdaA/I4HNo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-wEMGaywDOSSBQYQopQjqng-1; Thu, 29 Oct 2020 12:53:56 -0400
X-MC-Unique: wEMGaywDOSSBQYQopQjqng-1
Received: by mail-qk1-f197.google.com with SMTP id u16so2129506qkm.22
        for <ceph-devel@vger.kernel.org>; Thu, 29 Oct 2020 09:53:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=q7W3wrnJmrQCtzqZeZogCt+ocDUvuf2s4mP6AAkeh2c=;
        b=J6oMrnl1bVbtK5G2v6xKgxfwjdiLiVe0CG3kK4Zn0++6HF+LBVWw+hlv5R5gT/kPgZ
         oU8+y4cQuG9EbWyHmnOP6hgnIQo8vwy7AiXLcKA5kFyvEE8+3vu3jKYU3K9SHTOzNp/6
         yKE89tIQE3y2PwE+j6kMP7KvcWWxSBMEzj97VmrrBOKp5Oi0UQNmQxJysejzI3utctZ7
         KbwwjWFoHIJudxRQy3FAaUL99UWT1f871BJzpDUT+qQ15THgNy9UCDZ9Rravd+K1ZXj4
         qu+VcZVMUyymaPTuP23u3TPJCPjy7lcH0rPjnkXEM3HO9QusdaNXK4C7NqIZcpshKxXS
         JaOg==
X-Gm-Message-State: AOAM531AGVJdkul/QiSA2Dq0dUfnDC6m7v2UkVPWFK8qE4nNJDLzLHUp
        85vgyORC6H4JNef01kRThfm9dkFzphfK0USa7mSJRm2WOLo5ZyCLm3SxeHLDS/FS0eWcxjlfwhd
        mLmtjtyT9cDkMFZ5S7vortg==
X-Received: by 2002:a0c:8143:: with SMTP id 61mr5286379qvc.6.1603990435865;
        Thu, 29 Oct 2020 09:53:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHxYfyHT/UgOHTs3XGUfg3onlTlS55lf5cTzNTPb0Qk7ERNYecODkm64/LyRPq7JAnLtjR1A==
X-Received: by 2002:a0c:8143:: with SMTP id 61mr5286359qvc.6.1603990435654;
        Thu, 29 Oct 2020 09:53:55 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id v65sm1375884qkb.88.2020.10.29.09.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 09:53:54 -0700 (PDT)
Message-ID: <054c62ca910759e6f49d483363b2177351974663.camel@redhat.com>
Subject: Re: cephfs inode size handling and inode_drop field in struct
 MetaRequest
From:   Jeff Layton <jlayton@redhat.com>
To:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 29 Oct 2020 12:53:53 -0400
In-Reply-To: <b4726535239f4b0e723d3f45da3a7fcf1412c943.camel@redhat.com>
References: <b4726535239f4b0e723d3f45da3a7fcf1412c943.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-10-29 at 11:19 -0400, Jeff Layton wrote:
> I'm working on a F_SETLEASE implementation for kcephfs, and am hitting a
> deadlock of sorts, due to a truncate triggering a cap revoke at an
> inopportune time.
> 
> The issue is that truncates to a smaller size are always done via 
> synchronous call to the MDS, whereas a truncate larger does not if Fx
> caps are held. That synchronous call causes the MDS to issue the client
> a cap revoke for caps that the lease holds references on (Frw, in
> particular). 
> 
> The client code has been this way since the inception and I haven't been
> able to locate any rationale for it. Some questions about this:
> 
> 1) Why doesn't the client ever buffer a truncate to smaller size? It
> seems like that is something that could be done without a synchronous
> MDS call if we hold Fx caps.
> 
> 2) The client setattr implementations set inode_drop values in the
> MetaRequest, but as far as I can tell, those values end up being ignored
> by the MDS. What purpose does inode_drop actually serve? Is this field
> vestigial?


I think I answered the second question myself. It _is_ potentially used
to encoded a cap release into the call. That's not happening here
because of the extra references held by the lease. I think I see a
couple of potential fixes for that problem.

I think the first question is still valid though.
-- 
Jeff Layton <jlayton@redhat.com>

