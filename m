Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B260A6652F7
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Jan 2023 05:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjAKEyu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Jan 2023 23:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbjAKEys (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Jan 2023 23:54:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6DA264A
        for <ceph-devel@vger.kernel.org>; Tue, 10 Jan 2023 20:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673412849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwDGIIG2kEW7th9yR8DoIeZiikP/oVS4/IYm7KTM+N0=;
        b=brBsQQCOn3YNpLDRSqJ0fzxkPgWTd4vbAn6G6HjRvF4ftTEjYNlIg2wBSn3tcP5h2zfNIk
        jWqFpNqwVQdt3rHPjEQTY6pwwFqd6aMMsecCM9qO+H49BcBd/QzXarky/Q/461Wvi4a92Y
        V+yqgBm2DJ/BldL60Ie7/m7IEX5QWqQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-zA4dUd8bOB2dVR7i3WDj7g-1; Tue, 10 Jan 2023 23:54:08 -0500
X-MC-Unique: zA4dUd8bOB2dVR7i3WDj7g-1
Received: by mail-pg1-f198.google.com with SMTP id e5-20020a63f545000000b0049b36d5a272so6158037pgk.12
        for <ceph-devel@vger.kernel.org>; Tue, 10 Jan 2023 20:54:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AwDGIIG2kEW7th9yR8DoIeZiikP/oVS4/IYm7KTM+N0=;
        b=EitUGxqBSk0F+PCrsKLZ7MthyMFbtvAZkVCs6yUxEOE+DXCZtw1yrkTXryWLo+o6Bs
         NsZ6C7P7ozbYVBa8ugS4OLyMu2tzHVInkrQyTtwxbfi/PPUe6eO67H7x/LvTnvfq6mf8
         RfAswI2wcdX2Y6W39lrMPi6TM273q4KgdLqZ/o8sjubH4nmbmvF7fTAAn33Il1YqgBn5
         DQUb8fXZq9sW1NrHT4dA+r+dylI8sd2jUpNIDWqnXmzBtJVlHT9ha9R8UYKZWG5JLqfi
         Cok7eTb1Az4tE/OsilDcBEB9FdSbLzGAjRi/6vLenlo5g+dcj/ZOxAHmGid1f4VJQEuM
         Yxjw==
X-Gm-Message-State: AFqh2kqSNiU6cutfk0MlBXJiE2zK4xMewjA+uhvqhtxbZhfzFvkAK/Nw
        v4bf8qfLNkcmI1Uv1nkOCxWcH0+BDWQH0t4hdVFMotnSJK+xWTOtpQoZTpYr94pyLZWOCraejrE
        giBzjk59sCnfYBPXHbR6CtQ==
X-Received: by 2002:a17:903:50e:b0:189:bda4:4a39 with SMTP id jn14-20020a170903050e00b00189bda44a39mr68317510plb.49.1673412846854;
        Tue, 10 Jan 2023 20:54:06 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs+9rrIRD+6pRvHkwnX14gh2BCpLNg+4mxFg/ySKLAFpFMrHGq/R+Lf/NnqdSw7vAx/2ZYhMg==
X-Received: by 2002:a17:903:50e:b0:189:bda4:4a39 with SMTP id jn14-20020a170903050e00b00189bda44a39mr68317481plb.49.1673412846568;
        Tue, 10 Jan 2023 20:54:06 -0800 (PST)
Received: from [10.72.14.8] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902654b00b001895d87225csm8944870pln.182.2023.01.10.20.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 20:54:05 -0800 (PST)
Message-ID: <330d1f1b-02b2-ceb1-5df5-ef6ce0061eb2@redhat.com>
Date:   Wed, 11 Jan 2023 12:53:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] filelock: move file locking definitions to separate
 header file
Content-Language: en-US
To:     Jeff Layton <jlayton@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Steve French <stfrench@microsoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        devel@lists.orangefs.org, linux-xfs@vger.kernel.org
References: <20230105211937.1572384-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230105211937.1572384-1-jlayton@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 06/01/2023 05:19, Jeff Layton wrote:
> The file locking definitions have lived in fs.h since the dawn of time,
> but they are only used by a small subset of the source files that
> include it.
>
> Move the file locking definitions to a new header file, and add the
> appropriate #include directives to the source files that need them. By
> doing this we trim down fs.h a bit and limit the amount of rebuilding
> that has to be done when we make changes to the file locking APIs.
>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Acked-by: Chuck Lever <chuck.lever@oracle.com>
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Acked-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   arch/arm/kernel/sys_oabi-compat.c |   1 +
>   fs/9p/vfs_file.c                  |   1 +
>   fs/afs/internal.h                 |   1 +
>   fs/attr.c                         |   1 +
>   fs/ceph/locks.c                   |   1 +

ceph part looks good to me.

Thanks

- Xiubo


